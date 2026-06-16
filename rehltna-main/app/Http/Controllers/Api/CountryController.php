<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\City;
use App\Models\Country;
use App\Models\State;
use Illuminate\Http\JsonResponse;

class CountryController extends Controller
{
    use ResponseTrait;

    public function getCountries(): JsonResponse
    {
        $countries = Country::all();
        return $this->responseMessage(200, "Countries", $countries);
    }

    public function getStatesByCountryId($country_id): JsonResponse
    {
        $states = State::query()->where('country_id', $country_id)->get();
        return $this->responseMessage(200, "States", $states);
    }

    public function getCitiesByStateId($state_id): JsonResponse
    {
        $cities = City::query()->where('state_id', $state_id)->get();
        return $this->responseMessage(200, "Cities", $cities);
    }

}
