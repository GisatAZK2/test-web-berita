<?php

namespace App\Http\Controllers\V1;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user = User::all();

        if ($user->isEmpty()) {
            return response()->json([
                "status" => false,
                "messages" => "im but tu blow 🍆🍆",
                "data" => []
            ], 404);
        }

        return response()->json([
            "status" => true,
            "messages" => "Data Siswa",
            "Data" => $user
        ], 200);
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
        'user_name' => 'required|string|unique:users,user_name',
        'password' => 'required|string|min:8',
        'nama_user' => 'required|string'
       ]);

       $user = User::create([
            'user_name' => $request->user_name,
            'nama_user' => $request->nama_user,
            'password' => $request->password
       ]);

       return response()->json([
        "success" => true,
        "message" => "Data Inserted",
        "data" => $user
       ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(User $user)
    {
        $user = User::find($user->id);

        return response()->json([
            "status" => true,
            "messages" => "Data Berhasil Di Temukan",
            "data" => $user
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(User $user)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, User $user)
    {
        $user = User::find($user->id);

        $user->update($request->all());

        return response()->json([
            "status" => true,
            "messages" => "Data Anda Berhasil Di Update",
            "Data" => $user
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user)
    {
        $user->delete();

        return response()->json([
            "status" =>true,
            "messages" =>"Data Anda Berhasil Di Hapus"
        ], 200);
    }
}
