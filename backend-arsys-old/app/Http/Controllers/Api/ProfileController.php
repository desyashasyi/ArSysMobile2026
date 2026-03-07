<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Contracts\Support\Renderable;
use Auth;
use App\Models\Staff;
class ProfileController extends Controller
{
    public function profile(Request $request){
        $user = Auth::user();
        if($user != null && $user->hasRole('staff')){
            $profile = Staff::where('user_id', $user->id)->first();
            return response()->json([
                'success' => true,
                'id' => $profile->id,
                'role' => 1,
                'code' => $profile->code,
                'upi_code' => $profile->program_id,
                'nip' => $profile->nip,
                'old_nip' => $profile->old_nip,
                'front_title' => $profile->front_title,
                'rear_title' => $profile->rear_title,
                'first_name' => $profile->first_name,
                'last_name' => $profile->last_name,
                'duty_id' => $profile->duty_id,
                'specialization_id' => $profile->specialization_id,
                'program_id' => $profile->program_id,
                'phone' => $profile->phone,
                'email' => $profile->email,
            ]);
        }
        else {return response()->json([
            'success' => false,
            'message' => 'failed'
        ], 401);}
    }
}
