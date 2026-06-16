<?php

namespace App\Http\Controllers\Dashboard;

use App\Exports\ContactUsExport;
use App\Http\Controllers\Controller;
use App\Jobs\SendContactReplyJob;
use App\Models\ContactUs;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;
use Maatwebsite\Excel\Facades\Excel;
use Symfony\Component\HttpFoundation\BinaryFileResponse;

class ContactUsController extends Controller
{
    public function index(Request $request): view|string
    {
        $query = ContactUs::query();

        if ($request->has('search')) {
            $query->when($request->get('search'), function ($q) use ($request) {
                $q->where('name', 'like', "%{$request->get('search')}%")
                    ->orWhere('email', 'like', "%{$request->get('search')}%")
                    ->orWhere('phone', 'like', "%{$request->get('search')}%")
                    ->orWhere('message', 'like', "%{$request->get('search')}%");
            });
        }

        $contacts = $query->orderByRaw("FIELD(status, 'unread', 'read')")
            ->latest()
            ->paginate(10);

        if ($request->ajax()) {
            return view('pages.contact-us.partials.table', compact('contacts'))->render();
        }

        return view('pages.contact-us.index', compact('contacts'));

    }

    public function destroy($id): RedirectResponse
    {
        ContactUs::query()->findOrFail($id)->delete();
        return redirect()->back()->with('success', 'Message deleted successfully.');
    }

    public function bulkDelete(Request $request): RedirectResponse
    {
        $ids = $request->get('ids');
        if (!is_array($ids) || count($ids) === 0) {
            return redirect()->back()->with('warning', 'No messages selected for deletion.');
        }

        ContactUs::query()->whereIn('id', $ids)->delete();
        return redirect()->back()->with('success', 'Messages deleted successfully.');
    }

    public function replyMessage(Request $request, $id): RedirectResponse
    {
        $contact = ContactUs::query()->findOrFail($id);
        $reply = $request->get('reply');

        $contact->update([
            'reply' => $reply,
            'status' => 'read'
        ]);

        SendContactReplyJob::dispatch($contact, $reply);

        return redirect()->back()->with('success', 'Reply sent successfully via email.');

    }

    public function exportContactUsExcel(): BinaryFileResponse
    {
        return Excel::download(new ContactUsExport, 'contact-us.xlsx');
    }
}
