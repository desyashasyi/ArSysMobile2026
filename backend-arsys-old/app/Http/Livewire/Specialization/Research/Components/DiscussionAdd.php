<?php

namespace App\Http\Livewire\Specialization\Research\Components;

use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchReviewDiscussion;
use Auth;
use Intervention\Image\ImageManagerStatic as Image;
use Livewire\Component;

class DiscussionAdd extends Component
{
    public $researchId;
    public $comment;
    public function render()
    {
        return view('arsys::livewire.review-x.discussion.add-discussion');
    }

    public function mount($researchId){
        $this->researchId = $researchId;
    }

    public function save(){
        $this->validate([
              'comment' => 'required',
        ]);

        $researchCode = Research::where('id', $this->researchId)->first()->research_code;
        $dom = new \DomDocument();
        $dom->loadHtml( mb_convert_encoding($this->comment, 'HTML-ENTITIES', "UTF-8"), LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);
        $images = $dom->getElementsByTagName('img');

          // foreach <img> in the submited message
        foreach($images as $img){
            $src = $img->getAttribute('src');

              // if the img source is 'data-url'
            if(preg_match('/data:image/', $src)){

                // get the mimetype
                preg_match('/data:image\/(?<mime>.*?)\;/', $src, $groups);
                $mimetype = $groups['mime'];

                // Generating a random filename
                if(Auth::user()->hasRole('faculty')){
                    $filename = $researchCode.'-'.Auth::user()->staff->code.'-'.uniqid();
                    $fileurl = "review-discussion-images/" . $filename;
                }elseif(Auth::user()->hasRole('student')){
                    $filename = $researchCode.'-'.Auth::user()->student->number.'-'.uniqid();
                    $fileurl = "review-discussion-images/" . $filename;
                }


                $filepath = $fileurl.'.'.$mimetype;

                  // @see http://image.intervention.io/api/
                $image = Image::make($src);
                    // resize if required
                $image->resize(600, 500, function ($constraint) {
                    $constraint->aspectRatio();
                })->encode($mimetype, 100)	// encode file to the specified mimetype
                ->save(public_path($filepath));
                $new_src = asset($filepath);
                $file = readfile($new_src);
                $img->removeAttribute('src');
                $img->setAttribute('src', $new_src);
                $img->setAttribute('data-filename', $filename.'.'.$mimetype);
                $img->setAttribute('style', "width: 600.500px;");

            } // <!--endif
        } // <!--endforeach

        if(Auth::user()->hasRole('faculty')){
            $discussan_id = Auth::user()->staff->id;
        }elseif(Auth::user()->hasRole('student')){
            $discussan_id = Auth::user()->student->id;
        }
        ResearchReviewDiscussion::create([
            'message' => $dom->saveHTML(),
            'research_id' => $this->researchId,
            'discussant_id' => $discussan_id,
        ]);
        $this->emitUp('cancelAddDiscussion');
    }
}
