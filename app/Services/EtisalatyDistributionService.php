<?php

namespace App\Services;

use App\Models\EtisalatyContact;
use App\Models\User;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class EtisalatyDistributionService
{
    private const EMPLOYEE_CODES = [
        'zakaria' => 'Z',
        'mostafa' => 'M',
        'kamal' => 'K',
    ];

    public function rebalance(): array
    {
        return DB::transaction(function () {
            $contacts = EtisalatyContact::query()
                ->with(['employeeLinks' => fn ($query) => $query->with('employee')->orderBy('employee_id')])
                ->orderBy('id')
                ->lockForUpdate()
                ->get();

            EtisalatyContact::query()->update(['assigned_employee_id' => null]);

            $assignable = $contacts
                ->map(fn (EtisalatyContact $contact) => [
                    'contact' => $contact,
                    'employee_ids' => $contact->employeeLinks
                        ->filter(fn ($link) => $link->employee !== null && $this->isSupportedEmployee($link->employee))
                        ->pluck('employee_id')
                        ->unique()
                        ->sort()
                        ->values()
                        ->all(),
                ])
                ->filter(fn (array $item) => count($item['employee_ids']) > 0)
                ->sortBy(fn (array $item) => sprintf('%05d-%020d', count($item['employee_ids']), $item['contact']->id));

            $assignedCounts = [];

            foreach ($assignable as $item) {
                $employeeId = collect($item['employee_ids'])
                    ->sortBy(fn (int $id) => sprintf('%020d-%020d', $assignedCounts[$id] ?? 0, $id))
                    ->first();

                EtisalatyContact::query()
                    ->whereKey($item['contact']->id)
                    ->update(['assigned_employee_id' => $employeeId]);
                $assignedCounts[$employeeId] = ($assignedCounts[$employeeId] ?? 0) + 1;
            }

            return $this->summary();
        });
    }

    public function summary(): array
    {
        $contacts = EtisalatyContact::query()
            ->with(['employeeLinks.employee', 'assignedEmployee'])
            ->orderBy('id')
            ->get();

        $groupCounts = [
            'Z' => 0,
            'M' => 0,
            'K' => 0,
            'ZM' => 0,
            'ZK' => 0,
            'MK' => 0,
            'ZMK' => 0,
        ];

        foreach ($contacts as $contact) {
            $marker = $this->ownershipMarker($contact->employeeLinks);
            $groupCounts[$marker] = ($groupCounts[$marker] ?? 0) + 1;
        }

        return [
            'total_unique_numbers' => $contacts->count(),
            'total_unassigned' => $contacts->whereNull('assigned_employee_id')->count(),
            'assigned_per_employee' => $this->employeesQuery()
                ->orderBy('id')
                ->get()
                ->map(fn (User $employee) => [
                    'employee_id' => $employee->id,
                    'employee_name' => $employee->name,
                    'total_assigned' => $contacts->where('assigned_employee_id', $employee->id)->count(),
                ])
                ->values()
                ->all(),
            'ownership_groups' => $groupCounts,
        ];
    }

    public function ownershipMarker(Collection $links): string
    {
        $markers = $links
            ->filter(fn ($link) => $link->employee !== null && $this->isSupportedEmployee($link->employee))
            ->map(fn ($link) => $this->employeeMarker($link->employee?->name, $link->employee_id))
            ->unique()
            ->sortBy(function (string $marker) {
                $preferredOrder = ['Z' => 0, 'M' => 1, 'K' => 2];

                return sprintf('%02d-%s', $preferredOrder[$marker] ?? 99, $marker);
            })
            ->values();

        return $markers->isEmpty() ? 'UNOWNED' : $markers->implode('');
    }

    public function employeesQuery(): Builder
    {
        return User::query()
            ->whereNotNull('etisalaty_role')
            ->where(function (Builder $query) {
                foreach (array_keys(self::EMPLOYEE_CODES) as $employee) {
                    $query->orWhereRaw('LOWER(name) LIKE ?', ["%{$employee}%"])
                        ->orWhereRaw('LOWER(email) LIKE ?', ["%{$employee}%"]);
                }
            });
    }

    public function isSupportedEmployee(User $employee): bool
    {
        return $this->employeeCode($employee->name, $employee->email) !== null;
    }

    private function employeeMarker(?string $name, int $employeeId): string
    {
        return $this->employeeCode($name) ?? "#{$employeeId}";
    }

    private function employeeCode(?string $name, ?string $email = null): ?string
    {
        $identity = mb_strtolower(trim((string) $name) . ' ' . trim((string) $email));

        foreach (self::EMPLOYEE_CODES as $employee => $code) {
            if (str_contains($identity, $employee)) {
                return $code;
            }
        }

        return null;
    }
}
