<?php

namespace App\Http\Controllers\V1;

use App\Http\Controllers\Controller;
use App\Models\News;
use Illuminate\Http\Request;
use Intervention\Image\Format;
use Intervention\Image\Laravel\Facades\Image;


class NewsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
{
    $news = News::latest()->paginate(10);

    $news->getCollection()->transform(function ($item) {
        return [
            'id' => $item->id,
            'text_berita' => $item->text_berita,
            'gambar_url' => $item->gambar
                ? asset('storage/' . $item->gambar)
                : null,
        ];
    });

    return response()->json([
        "status" => true,
        "data" => $news
    ]);
}


    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
{
    $request->validate([
        'judul'=> 'string|required',
        'isi' => 'string|required',
        'picture' => 'nullable|image|max:2048'
    ]);

    $text_berita = [
        'judul' => $request->judul,
        'isi' => $request->isi,
        'date' => now()->toDateString(),
    ];

    $picture_path = null;

    if ($request->hasFile('picture')) {
        try {
            $image = $request->file('picture');
            $filename = pathinfo($image->getClientOriginalName(), PATHINFO_FILENAME);
            $filename = $filename . '-' . time() . '.webp';

            $img = Image::read($image)->encodeByExtension('webp', quality: 90);
            $img->save(storage_path('app/public/news/' . $filename));

            $picture_path = 'news/' . $filename;
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Gagal memproses gambar: ' . $e->getMessage()
            ], 500);
        }
    }

    $news = News::create([
        'text_berita' => $text_berita,
        'gambar' => $picture_path
    ]);

    return response()->json([
        "status" => true,
        "messages" => "Berita Sudah Di Tambahkan",
        "Data" => $news
    ], 200);
}


    /**
     * Display the specified resource.
     */
    public function show(News $news)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(News $news)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, News $news)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(News $news)
    {
        //
    }
}
