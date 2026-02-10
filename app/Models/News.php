<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class News extends Model 
{
    protected $fillable = ['gambar', 'text_berita'];

    protected $casts = [
        'text_berita' => 'array',
    ];
}
