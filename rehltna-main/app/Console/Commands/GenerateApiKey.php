<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Str;

class GenerateApiKey extends Command
{
    protected $signature = 'api-key:generate';
    protected $description = 'Generates a random API_KEY and saves it to the .env file';

    public function handle(): void
    {
        $key = Str::random(32);
        $envPath = base_path('.env');

        if (!file_exists($envPath)) {
            $this->error('.env file not found!');
            return;
        }

        $envContent = file_get_contents($envPath);

        if (preg_match('/^API_KEY=/m', $envContent)) {
            $envContent = preg_replace('/^API_KEY=.*/m', "API_KEY={$key}", $envContent);
        } else {
            $envContent .= "\nAPI_KEY={$key}\n";
        }

        file_put_contents($envPath, $envContent);

        $this->info("✅ API_KEY has been generated and saved to .env:");
        $this->line("🔑 {$key}");
    }
}

