<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User; // Assuming your User model is in App\Models
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Role; // Assuming you are using Spatie for roles

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Create the user if it doesn't exist
        $user = User::firstOrCreate(
            ['email' => 'deewahyu@upi.edu'],
            [
                'name' => 'Dee Wahyu',
                'password' => Hash::make('Ddw9889##'),
                // Add any other default fields required for a user
            ]
        );

        // Assign a role to the user, if roles are used
        // Assuming 'staff' role exists, or create it if not
        $staffRole = Role::firstOrCreate(['name' => 'staff']);
        $user->assignRole($staffRole);

        $adminRole = Role::firstOrCreate(['name' => 'admin']);
        $user->assignRole($adminRole);

        $user->assignRole('admin'); // Assign 'admin' role
        $user->assignRole('staff'); // Assign 'staff' role
    }
}
