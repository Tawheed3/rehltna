<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\DB;
use Spatie\Multitenancy\Models\Tenant as BaseTenant;
use Exception;

class Tenant extends BaseTenant
{
    use softDeletes;
    protected $connection = 'mysql';
    protected $guarded = [];

    public function user(): HasOne
    {
        return $this->hasOne(User::class);
    }
    public function getDatabaseName(): string
    {
        if (!$this->db_name) {
            throw new \Exception("Tenant database name is missing.");
        }

        return $this->db_name;
    }

    public function getDatabaseConnectionConfig(): array
    {
        if (!$this->db_name) {
            throw new \Exception("Tenant database name is missing.");
        }

        return [
            'driver' => 'mysql',
            'host' => $this->db_host ?: '127.0.0.1',
            'port' => $this->db_port ?: '3306',
            'database' => $this->db_name,
            'username' => $this->db_username,
            'password' => $this->db_password,
            'unix_socket' => null,
            'charset' => 'utf8mb4',
            'collation' => 'utf8mb4_unicode_ci',
        ];
    }

    public function makeCurrent(): static
    {
        try {
            config(['database.connections.tenant' => $this->getDatabaseConnectionConfig()]);
            DB::purge('tenant');
            DB::reconnect('tenant');
            DB::connection('tenant')->getPdo();

            return parent::makeCurrent();
        } catch (Exception $e) {
            if (request()->is('api/*')) {
                abort(response()->json(['code' => 400, 'message' => 'Tenant DB connection failed', 'data' => null]));
            }
            return redirect()->route('tenants.index')
                ->with('error', 'Failed to connect to tenant database: ' . $e->getMessage())->send();
            exit();
        }
    }


}

