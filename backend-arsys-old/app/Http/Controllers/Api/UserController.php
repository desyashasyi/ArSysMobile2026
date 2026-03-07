<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Mobile\User;
use Auth;
use Illuminate\Support\Facades\Hash;
class UserController extends Controller
{
    /*public function login(){
        if(Auth::attempt(['email' => request('email'), 'password' => request('password')])){
              $staff = false;
              if(Auth::user()->hasRole('staff')){
                  $staff = true;
              }

              $success = Auth::user()->createToken('appToken')->plainTextToken;
              // dd($success);
              return response()->json([
                  'success' => true,
                  'token' => $success,
                  'staff' => $staff,
              ]);
        } else{
              return response()->json([
                  'success' => false,
                  'message' => 'Invalid Email or Password',
                  ], 401);
        }
    }
    */
    public function login(){
      if(Auth::attempt(['email' => request('email'), 'password' => request('password')])){
          $user = Auth::user();
          $roles = $user->roles->first() ? $user->roles->first()->name : null;
          $success = $user->createToken('appToken')->plainTextToken;
          // dd($success);
          return response()->json([
              'success' => true,
              'token' => $success,
              'user' => $user,
              'roles' => $roles,
          ]);
      } else{
          return response()->json([
              'success' => false,
              'message' => 'Invalid Email or Password',
              ], 401);
      }
  }

    public function logout(Request $request){
      // dd(Auth::check());
        if (Auth::user()) {
            $user = Auth::user()->tokens();
            $user->delete();

            return response()->json([
              'success' => true,
              'message' => 'Logout successfully'
            ]);
          }else {
            return response()->json([
              'success' => false,
              'message' => 'Unable to Logout'
            ]);
          }
    }

    public function register(Request $request){
        $validator = Validator::make($request->all(), [
         'name' => ['required', 'string', 'max:255'],
         'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
         'password' => ['required', 'string', 'min:8'],
        ]);
        if($validator->fails()){
         return response()->json([
          'success' => false,
          'message' => $validator->errors(),
         ], 401);
        }
        $input = $request->all();
        $input['password'] = bcrypt($input['password']);
        $user = User::create($input);
        $success['token'] = $user->createToken('appToken')->accessToken;
        return response()->json([
         'success' => true,
         'token' => $success,
         'user' => $user
        ]);
       }

}


