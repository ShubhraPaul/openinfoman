module namespace page = 'http://basex.org/modules/web-page';

import module namespace csr_proc = "https://github.com/openhie/openinfoman/csr_proc";
import module namespace csd_mcs = "https://github.com/openhie/openinfoman/csd_mcs";
import module namespace csd_dm = "https://github.com/openhie/openinfoman/csd_dm";
import module namespace csd_webui =  "https://github.com/openhie/openinfoman/csd_webui";

declare   namespace   csd = "urn:ihe:iti:csd:2013";



declare function page:is_merge($search_name) {
  let $ufunction := csr_proc:get_updating_function_definition($search_name)
  let $ext := $ufunction//csd:extension[  @urn='urn:openhie.org:openinfoman:adapter' and @type='merge']
  return (count($ext) > 0) 
};


declare
  %rest:path("/CSD/csr/{$doc_name}/careServicesRequest/{$search_name}/adapter/merge")
  %output:method("xhtml")
  %rest:GET
  function page:show_endpoints($search_name,$doc_name) 
{  
    if (not(page:is_merge($search_name)) ) 
      then concat('Not a stored function for a merge: ' , $search_name    )
    else 
      let $action := csd_webui:generateURL(("/CSD/csr",$doc_name,"careServicesRequest",$search_name, "adapter/merge"))
      let $ufunction := csr_proc:get_updating_function_definition($search_name)
      let $contents := 
        <div class='container'>
	  <div class='row'>
            <h2>Merge into {$doc_name}</h2>
 	    <div class="col-md-8">
	      <h2>Merge Cached Service Directoriesn</h2>
	      <h3>{$ufunction/csd:description}</h3>
	      <form method='POST' action="{$action}">
		{
		  let $docs := csd_dm:registered_documents()
		  return 
		  <span>
		    {
		      for $doc in $docs
		      where not($doc = $doc_name)
		      return (<input type='checkbox'  name="merge" value="{$doc}">{$doc}</input>,<br/>)
		    }
		    
		    <br/>
		    <input type='submit' value='Merge'/>
		  </span>
		}
	      </form>
	    </div>
	  </div>
	</div>
      return csd_webui:wrapper($contents)
};




declare updating
  %rest:path("/CSD/csr/{$doc_name}/careServicesRequest/{$search_name}/adapter/merge")
(:  %output:method("xhtml") :)
  %rest:query-param("merge", "{$merge}")
  function page:perform_merge($search_name,$doc_name,$merge) 
{  
  let $doc :=  csd_dm:open_document($doc_name)
  let $function := csr_proc:get_function_definition($search_name)
  let $action := concat("/CSD/csr/",$doc_name,"/careServicesRequest/",$search_name, "/adapter/merge")
  let $requestParams :=
    <csd:requestParams function="{$search_name}" resource="{$doc_name}" base_url="{csd_webui:generateURL('')}">
      <documents > 
	{
          for $name in $merge
	  where not ($name = $doc_name)
	  return  <document resource="{$name}"/>
	}
      </documents>
    </csd:requestParams >

    return
      (
	csr_proc:process_updating_CSR_stored_results( $doc,$requestParams)
	,
	() (: csd_webui:redirect_out($action)  :)
      )
};

