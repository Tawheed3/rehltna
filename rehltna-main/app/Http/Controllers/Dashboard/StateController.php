<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Country;
use App\Models\State;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class StateController extends Controller
{

    public function index(): View
    {
        $states = State::query()
            ->with('country')
            ->paginate(10);
        $countries = Country::all();
        return view("pages.states.index", compact("states", 'countries'));
    }

    public function store(Request $request): RedirectResponse
    {
        try {

            $data = $request->all();
            State::query()->create($data);
            return redirect()->route("states.index")->with("success", "state created successfully");

        } catch (\Exception $e) {
            return redirect()->back()->with(["error" => $e->getMessage()]);
        }
    }

    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $state = State::query()->findOrFail($id);
            $data = $request->all();
            $state->update($data);

            return redirect()->route("states.index")->with("success", "state updated successfully");

        } catch (\Exception $e) {
            return redirect()->back()->with(["error" => $e->getMessage()]);
        }
    }


    public function destroy($id): RedirectResponse
    {
        try {

            $state = State::query()->findOrFail($id);
            $state->delete();

            return redirect()->route("states.index")->with("success", "state deleted successfully");

        } catch (\Exception $e) {
            return redirect()->back()->with(["error" => $e->getMessage()]);
        }
    }

    public function stateChangeStatus($id): JsonResponse
    {
        $state = State::query()->findOrFail($id);
        if ($state->status == 1) {
            $state->status = 0;
            $state->save();
        } else {
            $state->status = 1;
            $state->save();
        }
        return response()->json(['status' => $state->status]);
    }
}
