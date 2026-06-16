<?php

namespace App\Services;

use App\Models\Ai;
use Illuminate\Support\Facades\Http;

class AIService
{
    public function generateChatResponse($title, $count, $ai_model_id, $tenant_id): false|array
    {
        $ai_model = Ai::query()->findOrFail($ai_model_id);
        if ($ai_model) {
            if ($ai_model->type == 'Gemini') {
                return $this->geminiAiModel($title, $count, $ai_model->key, $tenant_id);
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    public function geminiAiModel($title, $count, $apiKey, $tenant_id): array
    {
        // 1. Get Active Languages
        $activeLangs = get_active_langs(); // ['en', 'ar', 'fr', 'de']
        $langsString = implode(', ', $activeLangs);

        // 2. Build the list of required keys dynamically
        $fieldKeys = [];
        foreach ($activeLangs as $lang) {
            $fieldKeys[] = "\"title_{$lang}\"";
            $fieldKeys[] = "\"slug_{$lang}\"";
            $fieldKeys[] = "\"short_description_{$lang}\"";
            $fieldKeys[] = "\"long_description_{$lang}\""; // Will map to 'description'
            $fieldKeys[] = "\"meta_title_{$lang}\"";
            $fieldKeys[] = "\"meta_description_{$lang}\"";
            $fieldKeys[] = "\"meta_keywords_{$lang}\"";
        }
        $fieldsString = implode("\n- ", $fieldKeys);

        // 3. Construct the dynamic prompt
        $message = "Write $count blog post ideas for a product called \"$title\".
        For each idea, provide translations for the following languages: [$langsString].
        Return the result in a STRICT JSON array format. Each entry must contain:
        - $fieldsString";

        $response = Http::timeout(60)->withHeaders([
            'Content-Type' => 'application/json',
        ])->post('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=' . $apiKey, [
            'contents' => [
                [
                    'parts' => [
                        ['text' => $message]
                    ]
                ]
            ]
        ]);

        if (!$response->successful()) {
            if ($response->status() === 429) {
                logger()->warning('Gemini quota exceeded', [
                    'tenant_id' => $tenant_id ?? null,
                    'retry_after' => $response->json('error.details.2.retryDelay') ?? null,
                ]);
                return [];
            }
            logger()->error('Gemini request failed', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);
            return [];
        }


        $text = $response['candidates'][0]['content']['parts'][0]['text'] ?? 'No result';
        // Improved Regex to catch JSON arrays even if wrapped in markdown code blocks
        preg_match('/\[.*\]/s', $text, $matches);

        if (isset($matches[0])) {
            $json = $matches[0];
            $array = json_decode($json, true);

            if (is_array($array)) {
                $blogs = [];

                foreach ($array as $post) {
                    $blogData = [];

                    // Loop through active languages to map fields dynamically
                    foreach ($activeLangs as $lang) {
                        $blogData['title_' . $lang] = $post['title_' . $lang] ?? '';
                        $blogData['slug_' . $lang] = $post['slug_' . $lang] ?? '';
                        $blogData['short_description_' . $lang] = $post['short_description_' . $lang] ?? '';
                        // Map 'long_description' from AI to 'description' in DB
                        $blogData['description_' . $lang] = $post['long_description_' . $lang] ?? '';
                        $blogData['meta_title_' . $lang] = $post['meta_title_' . $lang] ?? '';
                        $blogData['meta_description_' . $lang] = $post['meta_description_' . $lang] ?? '';
                        $blogData['meta_keywords_' . $lang] = $post['meta_keywords_' . $lang] ?? '';
                    }

                    $blogs[] = $blogData;
                }
                return $blogs;
            } else {
                return [];
            }
        } else {
            return [];
        }
    }
}
