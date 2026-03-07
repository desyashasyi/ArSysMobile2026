<?php

namespace App\Http\Livewire\Data;

use App\Models\ArSys\Staff;
use Rappasoft\LaravelLivewireTables\DataTableComponent;
use Rappasoft\LaravelLivewireTables\Views\Column;

class StaffsTable extends DataTableComponent
{
    protected $model = Staff::class;

    public function configure(): void
    {
        $this->setPrimaryKey('id');
        $this->setEagerLoadAllRelationsStatus(true);
    }

    public function columns(): array
    {
        return [
            Column::make("Id", "id"),
            Column::make("Code", "code")
                ->sortable(),
            Column::make("Upi code", "upi_code")
                ->sortable(),
            Column::make("SSO", "sso")
                ->sortable(),
            Column::make("Name")
                ->format(
                       fn($value, $row, Column $column) => $row->first_name . ' ' . $row->last_name
                )
                ->sortable(),
        ];
    }
}
