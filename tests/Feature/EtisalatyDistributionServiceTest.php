<?php

namespace Tests\Feature;

use App\Models\EtisalatyContact;
use App\Models\EtisalatyEmployeeContact;
use App\Models\User;
use App\Services\EtisalatyDistributionService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class EtisalatyDistributionServiceTest extends TestCase
{
    use RefreshDatabase;

    public function test_it_balances_shared_contacts_globally_without_assigning_outside_their_owners(): void
    {
        $zakaria = User::factory()->create(['name' => 'Zakaria', 'etisalaty_role' => 'employee']);
        $mostafa = User::factory()->create(['name' => 'Mostafa', 'etisalaty_role' => 'employee']);
        $kamal = User::factory()->create(['name' => 'Kamal', 'etisalaty_role' => 'employee']);

        foreach (range(1, 4) as $index) {
            $this->createContact([$zakaria], $index);
        }

        foreach (range(5, 8) as $index) {
            $this->createContact([$zakaria, $mostafa], $index);
        }

        foreach (range(9, 11) as $index) {
            $this->createContact([$zakaria, $mostafa, $kamal], $index);
        }

        $distribution = app(EtisalatyDistributionService::class);
        $distribution->rebalance();
        $summary = $distribution->rebalance();
        $contacts = EtisalatyContact::with('employeeLinks')->get();

        $this->assertSame(11, $summary['total_unique_numbers']);
        $this->assertSame(0, $summary['total_unassigned']);
        $this->assertSame([
            'Z' => 4,
            'M' => 0,
            'K' => 0,
            'ZM' => 4,
            'ZK' => 0,
            'MK' => 0,
            'ZMK' => 3,
        ], $summary['ownership_groups']);
        $this->assertSame([
            $zakaria->id => 4,
            $mostafa->id => 4,
            $kamal->id => 3,
        ], $contacts->countBy('assigned_employee_id')->all());

        foreach ($contacts as $contact) {
            $this->assertContains($contact->assigned_employee_id, $contact->employeeLinks->pluck('employee_id'));
        }
    }

    private function createContact(array $employees, int $index): void
    {
        $contact = EtisalatyContact::create([
            'phone_number' => '+9665' . str_pad((string) $index, 8, '0', STR_PAD_LEFT),
            'contact_name' => "Customer {$index}",
            'first_seen_at' => now(),
            'last_seen_at' => now(),
        ]);

        foreach ($employees as $employee) {
            EtisalatyEmployeeContact::create([
                'employee_id' => $employee->id,
                'contact_id' => $contact->id,
                'uploaded_at' => now(),
            ]);
        }
    }
}
