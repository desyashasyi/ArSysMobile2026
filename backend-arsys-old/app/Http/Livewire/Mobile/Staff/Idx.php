<?php

namespace App\Http\Livewire\Mobile\Staff;

use Livewire\Component;
use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Event;
use JeroenNoten\LaravelAdminLte\Events\BuildingMenu;
class Idx extends Component
{
    public function render()
    {
        return view('livewire.mobile.staff.idx');
    }

    public function boot(){
        Event::listen(BuildingMenu::class, function (BuildingMenu $event) {
            //dd($event->menu->remove('specialization_header'));
            $event->menu->remove('spec_research');
            $event->menu->remove('spec_event');
            $event->menu->remove('super_config');
            $event->menu->remove('super_user_manage');
            config(['adminlte.layout_topnav' => true]);
            config(['adminlte.classes_topnav_nav' => 'navbar-collapsed',]);
        });
    }
}
