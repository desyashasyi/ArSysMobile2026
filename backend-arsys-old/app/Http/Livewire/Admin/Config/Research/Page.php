<?php

namespace App\Http\Livewire\Admin\Config\Research;

use App\Models\ArSys\ResearchConfig;
use Auth;
use Livewire\Component;

class Page extends Component
{
    public $configs = null;
    public $researchTypes = null;
    public function render()
    {
        if(Auth::user()->sysrole){
            $this->configs = ResearchConfig::where('program_id', Auth::user()->sysrole->program_id)->get();
        }
        return view('livewire.admin.config.research.page');
    }

    /*public function generateConfig(){
        $configBase = ResearchConfigBase::all();
        foreach($configBase as $config){
            ResearchConfig::updateOrCreate([
                'program_id' => Auth::user()->staff->program_id,
                'config_base_id' => $config->id,
                'status' => $config->status,
            ]);
        }
        $researchTypeConfigBase = ResearchTypeBase::all();
        foreach($researchTypeConfigBase as $config){
            ResearchType::updateOrCreate([
                'program_id' => Auth::user()->staff->program_id,
                'research_type_base_id' => $config->id,
                'status' => 1,
            ]);
        }
    }*/

    public function setConfig ($configId){
        if(ResearchConfig::find($configId)->status == 1){
            ResearchConfig::find($configId)->update([
                'status' => null,
            ]);
        }else{
            ResearchConfig::find($configId)->update([
                'status' => 1,
            ]);

        }
    }


}
