<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\StaffController;
use App\Http\Controllers\Api\ProfileController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/login', [UserController::class, 'login']);
Route::post('/register', [UserController::class, 'register']);
Route::post('/logout', [UserController::class, 'logout'])->middleware('auth:sanctum');

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/profile', [ProfileController::class, 'profile']);
    // Staff specific routes
    Route::get('/staff/supervised-research', [StaffController::class, 'getSupervisedResearch']);
    Route::get('/staff/research-types', [StaffController::class, 'getResearchTypes']);
    Route::get('/staff/research/{researchId}', [StaffController::class, 'getResearchDetails']);
    Route::get('/staff/research/{researchId}/supervision-details', [StaffController::class, 'getResearchSupervisionDetails']);
    Route::post('/staff/research-supervisor/{supervisorId}/toggle-bypass', [StaffController::class, 'toggleResearchSupervisorBypass']);
    Route::post('/staff/research-supervise/{superviseId}/toggle-approval', [StaffController::class, 'toggleResearchSuperviseApproval']);
    Route::get('/staff/research/{researchId}/defense-approvals', [StaffController::class, 'getResearchDefenseApprovals']);
    Route::post('/staff/defense-approval/{approvalId}/toggle-decision', [StaffController::class, 'toggleDefenseApprovalDecision']);
    Route::get('/staff/research-supervise/{superviseId}/details', [StaffController::class, 'getResearchSuperviseMeetingDetails']);
    Route::post('/staff/research-supervise/{superviseId}/discussion', [StaffController::class, 'addResearchSuperviseDiscussion']);
    Route::delete('/staff/research-supervise-discussion/{discussionId}', [StaffController::class, 'deleteResearchSuperviseDiscussion']);

    // Event and Defense routes
    Route::get('/staff/events/{eventId}/participants', [StaffController::class, 'getEventParticipants']);
    Route::post('/staff/events/examiners/{examinerId}/presence', [StaffController::class, 'toggleExaminerPresence']);
    Route::get('/staff/events/participants/{participantId}', [StaffController::class, 'getDefenseParticipantDetails']);
    Route::post('/staff/events/participants/{participantId}/score', [StaffController::class, 'submitScore']);
});
