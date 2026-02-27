<div>
    <div class="row text-left">
        <div class="col-md-12 offset-sm-0">
           <div class="card card-outline card-purple">
                
                <div class="card-body">
                    <div class="row">
                        <div class="text-left col-md-12">
                            <b>Research Remark and Discussion</b> <span class="fa fa-xs fa-plus-circle" wire:click="addRemark" style="color: green; cursor:pointer"></span>
                            
                        </div>
                    </div>
                    <div x-data="{remarkEditor : @entangle('remarkEditor') }">
                        <div x-show="remarkEditor">
                            <div class="row">
                                <div class="text-right col-md-12">
                                    <i class="fa fa-times-circle" wire:click="addRemark" style="color: red; cursor:pointer" ></i>
                                </div>
                            </div>
                            <div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="form-group" wire:ignore>
                                            <textarea type="text" wire:model="message" input="message" name="message" id="message" class="message"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="text-left col-md-12">
                                    <x-adminlte-button wire:click="save" theme="success" class="btn-sm" label="Save remark" icon="fa fa-save"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="row">
                        <div class="text-left col-md-12">
                            @if($remarks)
                                @foreach ($remarks as $remark)
                                    <div class="row">
                                        @if($remark->user)
                                            @if(strlen($remark->user->sso) < 9)
                                                <div  style="color:green" class="text-right col-md-2">
                                                    <b>{{$remark->user->student->first_name}}</b>
                                                </div>
                                            @else
                                                <div style="color:red" class="text-right col-md-2">
                                                    <b>{{$remark->user->staff->code}}</b>
                                                </div>
                                            @endif
                                        @endif
                                        
                                        <div class="text-left col-md-10">
                                            <i>
                                                {{\Carbon\Carbon::parse($remark->created_at)->format('d F Y H:i')}}
                                            </i>
                                            @if($remark->discussant_id == Auth::user()->id)
                                                |
                                                <i wire:click="deleteMessage({{ $remark->id }})"  class="fa fa-times-circle fa-sm" style ="cursor: pointer; color:red" aria-hidden="true"></i>
                                                <i wire:click="editMessage({{ $remark->id }})"  class="fa fa-edit fa-sm" style ="cursor: pointer; color:green" aria-hidden="true"></i>
                                            @endif
                                            <br>
                                            {!!$remark->message!!} 
                                        </div>
                                    </div>
                                @endforeach
                                {{$remarks->links()}}
                            @endif   
                        </div>
                    </div>   
                </div>    
           </div>
        </div>            
    </div>
    <script>
        $('#message').summernote({
            tabsize: 2,
            height: 60,
            toolbar: [
                //['style', ['style']],
                ['font', ['bold', 'underline', 'italic','clear']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']],
                //['table', ['table']],
                //['insert', ['link', 'video']],
                ['insert', ['link']],
                ['view', ['fullscreen']]
                //['view', ['fullscreen', 'codeview', 'help']]
            ],
            callbacks: {
                onChange: function(contents, $editable) {
                    @this.set('message', contents);
                }
            }
        });
        window.addEventListener('setSummernoteRemark', event => {
            $("#message").set('message', contents);
        });
    </script>
</div>