<?php

use App\Models\Config_Sympozia;
use App\Models\User;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

/*Route::get('/', function () {
    /*if(Config_Sympozia::where('code', 'FRP')->first()->status)
        return view('welcome');
    else
    */
        //return redirect()->route('arsys.home');
        //return view('welcome');
//});


Route::get('/', function () {
    /*if(Config_Sympozia::where('code', 'FRP')->first()->status)
        return view('welcome');
    else
    */
        //return redirect()->route('arsys.home');
        Auth::login(User::where('name', 'Guest')->first());
        return view('livewire.idx');
})->name('arsys.home');

//Auth::routes();
Auth::routes(['register' => false]);


Route::post('/user/refresh', function () {
    \Session::flush();
    //cas()->logout();
    return redirect('/');
})->name('user.refresh');
//Route::get('/arsys.home', \App\Http\Livewire\Arsys\Idx::class)->name('arsys.home');
//Route::get('/', \App\Http\Livewire\Arsys\Idx::class)->name('arsys.home');
Route::get('/auth/sso-upi', \App\Http\Livewire\Auth\SsoUpi::class)->name('arsys.sso-upi')->middleware('cas.auth');

//Route::get('/arsys/logout', \App\Http\Livewire\Arsys\Idx::class)->name('arsys.logout')->middleware('cas.auth');
Route::post('/logout', function () {
    \Session::flush();
    //cas()->logout();
    return redirect('/');
})->name('arsys.logout');
Route::post('/logout', \App\Http\Livewire\Logout::class)->name('arsys.logout');
Route::get('/staff', \App\Http\Livewire\Staff\Idx::class)->name('arsys.staff');
Route::get('/staff/research', \App\Http\Livewire\Staff\Research\Idx::class)->name('arsys.staff.research');
Route::get('/staff/review', \App\Http\Livewire\Staff\Review\Idx::class)->name('arsys.staff.review');
Route::get('/staff/event/defense', \App\Http\Livewire\Staff\Event\Defense\Idx::class)->name('arsys.staff.event.defense');
Route::get('/staff/event/seminar', \App\Http\Livewire\Staff\Event\Seminar\Idx::class)->name('arsys.staff.event.seminar');
Route::get('/staff/event/final-defense', \App\Http\Livewire\Staff\Event\FinalDefense\Idx::class)->name('arsys.staff.event.final-defense');

Route::get('/student', \App\Http\Livewire\Student\Idx::class)->name('arsys.student');
Route::get('/user/profile/create', \App\Http\Livewire\User\Profile\Create\Idx::class)->name('arsys.user.profile.create');
Route::get('/user/profile/view', \App\Http\Livewire\User\Profile\View\Idx::class)->name('arsys.student.profile');
Route::get('/user/profile/edit', \App\Http\Livewire\User\Profile\Edit\Idx::class)->name('arsys.user.profile.edit');
Route::get('/admin', \App\Http\Livewire\Admin\Idx::class)->name('arsys.admin');
Route::get('/admin/config/research', \App\Http\Livewire\Admin\Config\Research\Idx::class)->name('arsys.admin.config.research');
Route::get('/admin/user', \App\Http\Livewire\Admin\User\Idx::class)->name('arsys.admin.user');
Route::get('/admin/config/institution', \App\Http\Livewire\Admin\Config\Institution\Idx::class)->name('arsys.admin.config.institution');
Route::get('/admin/staff', \App\Http\Livewire\Admin\Staff\Idx::class)->name('arsys.admin.staff');
Route::get('/admin/student', \App\Http\Livewire\Admin\Student\Idx::class)->name('arsys.admin.student');
Route::get('/admin/login-as-program', \App\Http\Livewire\Admin\LoginAsProgram\Idx::class)->name('arsys.admin.login-as-program');

Route::get('/student/research', \App\Http\Livewire\Student\Research\Idx::class)->name('arsys.student.research');
Route::get('/telegram', \App\Http\Livewire\Components\Telegram\Idx::class)->name('arsys.telegram');
//Route::get('/email', \App\Http\Livewire\Arsys\Components\Email\Idx::class)->name('arsys.email');

Route::get('/specialization/research/sias', \App\Http\Livewire\Specialization\Research\Sias\Idx::class)->name('arsys.specialization.research.sias');
Route::get('/specialization/research/reject', \App\Http\Livewire\Specialization\Research\Reject\Idx::class)->name('arsys.specialization.research.reject');
Route::get('/specialization/research/new', \App\Http\Livewire\Specialization\Research\NewProposal\Idx::class)->name('arsys.specialization.research.new');
Route::get('/specialization/research/being-reviewed', \App\Http\Livewire\Specialization\Research\BeingReviewed\Idx::class)->name('arsys.specialization.research.being-reviewed');
Route::get('/specialization/research/in-progress', \App\Http\Livewire\Specialization\Research\InProgress\Idx::class)->name('arsys.specialization.research.in-progress');
Route::get('/specialization/research/login-as', \App\Http\Livewire\Specialization\Research\LoginAs\Idx::class)->name('arsys.specialization.research.login-as');
Route::get('/specialization/event', \App\Http\Livewire\Specialization\Event\Idx::class)->name('arsys.specialization.event');
Route::get('/specialization/event/defense', \App\Http\Livewire\Specialization\Event\Defense\Idx::class)->name('arsys.specialization.event.defense');
Route::get('/specialization/event/final-defense', \App\Http\Livewire\Specialization\Event\FinalDefense\Idx::class)->name('arsys.specialization.event.final-defense');
Route::get('/specialization/event/seminar', \App\Http\Livewire\Specialization\Event\Seminar\Idx::class)->name('arsys.specialization.event.seminar');

Route::get('/event', \App\Http\Livewire\Specialization\Event\Idx::class)->name('arsys.event');

//Route::get('/program/research/proposal', \App\Http\Livewire\Arsys\Program\Research\Proposal\Idx::class)->name('arsys.program.research.proposal');
Route::get('/sa/config/program', \App\Http\Livewire\SuperAdmin\Config\Program\Idx::class)->name('arsys.sa.config.program');
Route::get('/sa/staff', \App\Http\Livewire\SuperAdmin\Staff\Idx::class)->name('arsys.sa.staff');
Route::get('/sa/student', \App\Http\Livewire\SuperAdmin\Student\Idx::class)->name('arsys.sa.student');
Route::get('/sa/telegram', \App\Http\Livewire\SuperAdmin\Telegram\Idx::class)->name('arsys.sa.telegram');
Route::get('/sa/reset-sp', \App\Http\Livewire\SuperAdmin\Utilities\ResetSp\Idx::class)->name('arsys.sa.reset-sp');
//Route::get('/sa/active-research', \App\Http\Livewire\ArSys\SuperAdmin\Utilities\SetActiveResearch\Idx::class)->name('arsys.sa.set-active-research');


Route::get('/administration/research/proposal', \App\Http\Livewire\Administration\Research\Proposal\Idx::class)->name('arsys.administration.research.proposal');

Route::get('/program', \App\Http\Livewire\Program\Idx::class)->name('arsys.program');
Route::get('/program/final-defense/approval', \App\Http\Livewire\Program\Research\FinalDefense\Approval\Idx::class)->name('arsys.program.final-defense.approval');
Route::get('/program/final-defense', \App\Http\Livewire\Program\Research\FinalDefense\Idx::class)->name('arsys.program.final-defense');
Route::get('/program/defense', \App\Http\Livewire\Program\Research\Defense\Idx::class)->name('arsys.program.defense');


Route::get('/auth/callback', \App\Http\Livewire\Auth\SsoGoogle::class)->name('auth.callback');
Route::get('/auth/redirect', function () {
    return Socialite::driver('google')->redirect();
})->name('arsys.sso-google');
//Route::get('/auth/email/{googleEmail}/{googleId}', \App\Http\Livewire\Auth\Email\Idx::class)->name('arsys.auth.email');
Route::get('/auth/email/{userCode}', \App\Http\Livewire\Auth\Email\Idx::class)->name('arsys.auth.email');
Route::get('/auth/mobile', \App\Http\Livewire\Auth\Mobile\Idx::class)->name('auth.mobile');


//MOBILE
Route::get('/mobile/staff', \App\Http\Livewire\Mobile\Staff\Idx::class)->name('mobile.staff');
