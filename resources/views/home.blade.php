<div>
    <h1>Ini halaman amba</h1>

    @if (Route::has('about'))
        <a href="{{ route('about') }}">About Page</a>
    @endif
</div>