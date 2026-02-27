<?php

namespace App\Http\Livewire\Data;

use App\Models\ArSys\Program;
use Rappasoft\LaravelLivewireTables\DataTableComponent;
use Rappasoft\LaravelLivewireTables\Views\Column;

class ProgramsTable extends DataTableComponent
{
    protected $model = Program::class;

    public function configure(): void
    {
        $this->setPrimaryKey('id');
    }

    public function columns(): array
    {
        return [
            Column::make("Id", "id")
                ->sortable(),
            Column::make("Code", "code")
                ->sortable(),
            Column::make("Description", "description")
                ->sortable(),
        ];
    }
}
