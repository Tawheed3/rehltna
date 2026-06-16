<?php

namespace App\Jobs;

use App\Models\Blog;
use App\Models\Tenant;
use App\Services\AIService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class GenerateBlogsFromAI implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected string $title;
    protected int $count;
    protected int $ai_model_id;
    protected int $category_id;
    protected int $tenant_id;

    public function __construct(string $title, int $count, int $ai_model_id, int $category_id, int $tenant_id)
    {
        $this->title = $title;
        $this->count = $count;
        $this->ai_model_id = $ai_model_id;
        $this->category_id = $category_id;
        $this->tenant_id = $tenant_id;
    }

    public function handle(): void
    {
        $tenant = Tenant::query()->findOrFail($this->tenant_id);
        $tenant->makeCurrent();

        $ai = new AIService;

        try {

            $response = $ai->generateChatResponse($this->title, $this->count, $this->ai_model_id, $this->tenant_id);
            if (!$response) {
                logger()->warning("AI response empty – skipped", ['tenant_id' => $this->tenant_id]);
                if ($ai->lastRetryAfter ?? false) {
                    $this->release($ai->lastRetryAfter);
                }

                return;
            }

            foreach ($response as $item) {
                $item['category_id'] = $this->category_id;
                Blog::query()->create($item);
            }
        } catch (\Exception $e) {
            if (str_contains($e->getMessage(), 'quota')) {
                preg_match('/retry in ([0-9.]+)s/i', $e->getMessage(), $matches);
                $delay = isset($matches[1]) ? ceil($matches[1]) : 30; // default 30s
                logger()->warning("Gemini quota exceeded", [
                    'tenant_id' => $this->tenant_id,
                    'retry_after' => "{$delay}s"
                ]);
                $this->release($delay);
            } else {
                logger()->error("AI response is empty", ['tenantId' => $this->tenant_id]);
                throw $e;
            }
        }
    }


}
