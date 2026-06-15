<div class="table-responsive">
    <table class="table text-md-nowrap" id="table">
        <thead>
        <tr>
            <th>#</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Status</th>
            <th>Options</th>
        </tr>
        </thead>
        <tbody>
        @foreach($applyJobs as $applyJob)
            <tr>
                <td>{{ $loop->iteration }}</td>
                <td>{{ $applyJob->name }}</td>
                <td>{{ $applyJob->email }}</td>
                <td>{{ $applyJob->phone }}</td>
                <td>
                    @if($applyJob->status == 'pending')
                        <span class="text-warning">Pending</span>
                    @elseif($applyJob->status == 'accepted')
                        <span class="text-success">Accepted</span>
                    @else
                        <span class="text-danger">Rejected</span>
                    @endif
                </td>
                <td>
                    @if($applyJob->status !== 'rejected')
                        <a class="btn btn-sm btn-outline-success"
                           title="Show CV"
                           data-bs-effect="effect-scale"
                           href="{{ route('apply-jobs.show',encrypt($applyJob->id)) }}"><i class="las la-eye"></i></a>
                    @endif
                    @if($applyJob->status == 'rejected')
                        <a class="modal-effect btn btn-sm btn-outline-danger delete-btn"
                           data-bs-effect="effect-scale"
                           data-route="{{ route('apply-jobs.destroy',$applyJob->id) }}"
                           data-bs-toggle="modal" href="#" data-bs-target="#deleteModal"><i
                                class="las la-trash"></i></a>
                    @endif
                </td>
            </tr>

        @endforeach
        </tbody>
    </table>
    {!! $applyJobs->appends(['search' => request('search'), 'status' => request('status')])->links() !!}

</div>

