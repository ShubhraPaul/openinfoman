module namespace page = 'http://basex.org/modules/web-page';

import module namespace svs_lsvs = "https://github.com/openhie/openinfoman/svs_lsvs";
declare namespace svs = "urn:ihe:iti:svs:2008";
import module namespace csd_webui =  "https://github.com/openhie/openinfoman/csd_webui";








declare
  %rest:path("/CSD/SVS/initSharedValueSet/svs/{$id}")
  %rest:GET
  %output:method("xhtml")
  function page:get_svs_menu($id)
{
  let $response := page:svs_menu($id) 
  return csd_webui:nocache(csd_webui:wrapper($response))
};



declare
  %rest:path("/CSD/SVS/RetrieveMultipleValueSets")
  %rest:GET
  %rest:query-param("ID", "{$ID}")
  %rest:query-param("DisplayNameContains" ,"{$DisplayNameContains}",'')
  %rest:query-param("SourceContains" ,"{$SourceContains}",'')
  %rest:query-param("PurposeContains" ,"{$PurposeContains}",'')
  %rest:query-param("DefinitionContains" ,"{$DefinitionContains}",'')
  %rest:query-param("GroupContains" ,"{$GroupContains}",'')
  %rest:query-param("GroupOID" ,"{$GroupOID}",'')
  %rest:query-param("EffectiveDateBefore" ,"{$EffectiveDateBefore}",'')
  %rest:query-param("EffectiveDateAfter"  ,"{$EffectiveDateAfter}",'')
  %rest:query-param("ExpirationDateBefore" ,"{$ExpirationDateBefore}",'')
  %rest:query-param("ExpirationDateAfter" ,"{$ExpirationDateAfter}",'')
  %rest:query-param("CreationDateBefore" ,"{$CreationDateBefore}",'')
  %rest:query-param("CreationDateAfter" ,"{$CreationDateAfter}",'')
  %rest:query-param("RevisionDateBefore" ,"{$RevisionDateBefore}",'')
  %rest:query-param("RevisionDateAfter" ,"{$RevisionDateAfter}",'')
  function page:get_shared_value_set(
    $ID,$DisplayNameContains,$SourceContains,$PurposeContains,$DefinitionContains,$GroupContains,$GroupOID,
    $EffectiveDateBefore,$EffectiveDateAfter,$ExpirationDateBefore,$ExpirationDateAfter,
    $CreationDateBefore,$CreationDateAfter,$RevisionDateBefore,$RevisionDateAfter)
{ 
let $filter := <RetrieveMultipleValueSetsRequest
 ID="{$ID}"
 DisplayNameContains="{$DisplayNameContains}"
 SourceContains="{$SourceContains}"
 PurposeContains="{$PurposeContains}"
 DefinitionContains="{$DefinitionContains}"
 GroupContains="{$GroupContains}"
 GroupOID="{$GroupOID}"
 EffectiveDateBefore="{$EffectiveDateBefore}"
 EffectiveDateAfter="{$EffectiveDateAfter}"
 ExpirationDateBefore="{$ExpirationDateBefore}"
 ExpirationDateAfter="{$ExpirationDateAfter}"
 CreationDateBefore="{$CreationDateBefore}"
 CreationDateAfter="{$CreationDateAfter}"
 RevisionDateBefore="{$RevisionDateBefore}"
 RevisionDateAfter="{$RevisionDateAfter}"
/>
return svs_lsvs:get_multiple_described_value_sets($filter) 
};


(:ValueSet have @id while DesribedValueSet has @ID:)
declare
  %rest:path("/CSD/SVS/RetrieveValueSet")
  %rest:GET
  %rest:query-param("ID", "{$id}",'')
  %rest:query-param("lang", "{$lang}",'') 
  %rest:query-param("version", "{$version}",'')
  function page:get_single_version_value_set($id,$version,$lang)
{
  svs_lsvs:get_single_version_value_set($id,$version,$lang) 
};




declare updating
  %rest:path("/CSD/SVS/registerRemoteValueSet/basic_auth")
  %rest:POST
  %output:method("xhtml")
  %rest:query-param("id", "{$id}")
  %rest:query-param("url", "{$url}")
  %rest:query-param("password", "{$password}")
  %rest:query-param("username", "{$username}")
  %rest:GET
  function page:register_basic_auth($id,$url,$username,$password) 
{

  (
    let $credentials := <credentials type="basic_auth" username="{$username}" password="{$password}"/>
    return svs_lsvs:register_remote_value_set($id,$url,$credentials)
      ,
  csd_webui:redirect_out("CSD/SVS/registerRemoteValueSet")
  )

};


declare updating
  %rest:path("/CSD/SVS/registerRemoteValueSet/basic_auth/{$id}")
  %output:method("xhtml")
  %rest:POST
  %rest:query-param("url", "{$url}")
  %rest:query-param("password", "{$password}")
  %rest:query-param("username", "{$username}")
  %rest:GET
  function page:update_basic_auth($id,$url,$username,$password) 
{

  (
    let $credentials := <credentials type="basic_auth" username="{$username}" password="{$password}"/>
    return svs_lsvs:register_remote_value_set($id,$url,$credentials)
      ,
  csd_webui:redirect_out("CSD/SVS/registerRemoteValueSet")
  )

};

declare updating   
  %rest:path("/CSD/SVS/registerRemoteValueSet/update_cache/{$id}")
  %rest:GET
  function page:update_cache($id)
{ 
(
  svs_lsvs:update_cache($id)   ,
  csd_webui:redirect_out("CSD/SVS/registerRemoteValueSet")
)

};

declare updating   
  %rest:path("/CSD/SVS/registerRemoteValueSet/update_caches")
  %rest:GET
  function page:update_caches()
{ 
  (
    for $id in  svs_lsvs:get_remote_value_set_ids()
    return svs_lsvs:update_cache($id)
    ,
    csd_webui:redirect_out("CSD/SVS/registerRemoteValueSet")
  )

};

declare
  %rest:path("/CSD/SVS/registerRemoteValueSet") 
  %output:method("xhtml")
  function page:removeValueSetMenu()
{
  let $content :=
   <div>
     <div class='row'>
       <div class="col-md-4">
	 <h3>Add New Remote Value Set (Basic Auth)</h3>
	 <form method='post' action="{csd_webui:generateURL('/CSD/SVS/registerRemoteValueSet/basic_auth')}">
	   <ul>
	     <li><label for='id'>ID</label><input class='pull-right'  size="35"      name='id' type="text" value=""/>   </li>
	     <li><label for='url'>URL</label><input  class='pull-right' size="35"     name='url' type="text" value=""/>   </li>
	     <li><label for='username'>User Name</label><input  class='pull-right' size="35"     name='username' type="text" value=""/>   </li>
	     <li><label for='password'>Password</label><input  class='pull-right' size="35"     name='password' type="password" value=""/>   </li>
	   </ul>
	   <input type='submit' />
	 </form> 
	 <gr/>
	 <div >
	   <h2>Global Operations</h2>
	   <ul>
	     <li> <a href="{csd_webui:generateURL('CSD/SVS/registerRemoteValueSet/update_caches')}">Update Local Cache of All Remote Value Sets</a></li>
	   </ul>
	 </div>

       </div>
       <div class="col-md-4">
	 <h3>Registered Remote Value Sets</h3>
	 {
	   for $id in  svs_lsvs:get_remote_value_set_ids()
	   let $url := svs_lsvs:get_remote_value_set_url($id) 
	   return
	     <div id='svc-{$id}'>
	       <h4>Value Set ID: {$id}</h4>
	       <ul>
		 <li><a href="{csd_webui:generateURL(('/CSD/SVS/registerRemoteValueSet/update_cache',$id))}">Update</a> local cache of value set.</li>
		 <li><a href="{csd_webui:generateURL(concat('/CSD/SVS/RetrieveValueSet?ID=',$id))}">View</a> local cache of value set.</li>
	       </ul>
	       <br/>
	       <form method='post' action="{csd_webui:generateURL(('/CSD/SVS/registerRemoteValueSet/basic_auth',$id))}">
		 <ul>
		   <li><label for='url'>URL</label><input  class='pull-right' size="35"     name='url' type="text" value="{$url}"/></li>
		   <li><label for='username'>User Name</label><input  class='pull-right' size="35"     name='username' type="text" value=""/>   </li>
		   <li><label for='password'>Password</label><input  class='pull-right' size="35"     name='password' type="password" value=""/>   </li>
		 </ul>
		 <input type='submit' />
	       </form> 
	     </div>
	 }


       </div>
     </div>
   </div>

   return csd_webui:wrapper($content)


};







declare updating   
  %rest:path("/CSD/SVS/initSharedValueSet/svs/{$id}/load")
  %rest:GET
  function page:load($id)
{ 
(
  svs_lsvs:load($id)   ,
  csd_webui:redirect_out("CSD/SVS/initSharedValueSet")
)
};


declare updating   
  %rest:path("/CSD/SVS/initSharedValueSet/svs/{$id}/reload")
  %rest:GET
  function page:reload($id)
{ 
(
  svs_lsvs:reload($id)   ,
  csd_webui:redirect_out("CSD/SVS/initSharedValueSet")
)
};

declare
  %rest:path("/CSD/SVS/initSharedValueSet/svs/{$id}/lookup")
  %rest:GET
  %rest:query-param("code","{$code}")
  %rest:query-param("lang", "{$lang}",'')
  %rest:query-param("version", "{$version}",'')
  %output:method("xhtml")
  function page:lookup_code($id,$code,$version,$lang) 
{
  let $response :=
  (<h2>Code: {$code}</h2>,

  for $concept in svs_lsvs:get_single_version_code($code,$id,$version,$lang)
  let $code_list := $concept/..
  let $value_set := $code_list/..
  return <span>
    <h3>Value Set: {text{$id}} ({text{$value_set/@displayName}}), ({text{$value_set/@version}})</h3>
    <ul>
      <li>displayName: {text{$concept/@displayName}}</li>
      <li>codeSystem: {text{$concept/@codeSystem}}</li>
    </ul>
    <a href="{csd_webui:generateURL('CSD/SVS/initSharedValueSet')}">Return</a>
  </span>
  )
  return csd_webui:wrapper($response)
};


declare function page:wrapper_double($responseA,$responseB) {
 let $content := 
 <div class='row'>
   <div class="col-md-6">
     {$responseA}
   </div>
   <div class="col-md-4">
     {$responseB}
   </div>
 </div>
 return csd_webui:wrapper($content)
};

declare 
  %rest:path("/CSD/SVS/initSharedValueSet")
  %rest:GET
  %output:method("xhtml") 
  function page:svs_list()
{
 csd_webui:nocache( page:wrapper_double(
    <span >
      <h2>Shared Value Sets</h2>
      <p>
      FILES:
      {svs_lsvs:get_sample_value_set_list()}
      </p>
      <p>
      {svs_lsvs:get_all_value_set_list()}
      </p>
      <ul>
	{for $set in svs_lsvs:get_all_value_set_list()//svs:DescribedValueSet
	(:ValueSet have @id while DesribedValueSet has @ID:)
	let $id := text{$set/@ID}
	let $displayName := text{$set/@displayName}
	order by $set/@ID
	return 
	<li>
	  <a href="{csd_webui:generateURL(('CSD/SVS/initSharedValueSet/svs',$id))}">{$displayName} ({$id})</a>
	  <br/>
	  {page:svs_menu($id)}
	</li>
	}
      </ul>
    </span>
    ,
    <span>
      <h2>Retrieve Multiple</h2>
      <form action="{csd_webui:generateURL('/CSD/SVS/RetrieveMultipleValueSets')}">
	<ul>
	  <li>ID: <input name="ID"/></li>
	</ul>
	<input type="submit" value="search"/>
      </form>
    </span>
	       )

      )

};



declare function page:svs_menu($id) {
  let $lang := ''
  let $version := ''
  let $set := svs_lsvs:get_all_value_set_list()//svs:DescribedValueSet[@ID = $id]
  return 
    if (not($set)) then (<b>{$set}</b>) else 
      let $disp := text{$set/@displayName}
      return <ul>
	{if ($set/@file) then
	  if (not(svs_lsvs:exists($id))) then
          <li><a href="{csd_webui:generateURL(('CSD/SVS/initSharedValueSet/svs',$id,'load'))}">Initialize {$id} ({$disp})</a> </li>
          else 
	  (
	  <li><a href="{csd_webui:generateURL((concat('CSD/SVS/RetrieveValueSet?ID=',$id)))}">Get {$id}</a></li>,
	  <li><a href="{csd_webui:generateURL(('/CSD/SVS/initSharedValueSet/svs',$id,'reload'))}">Reload {$id}</a></li>,
	  <li><form action="{csd_webui:generateURL(('/CSD/SVS/initSharedValueSet/svs',$id,'lookup'))}"><label for="code">Lookup Code</label><input name="code" type="text"/><input type="submit"/></form></li>
	  )
        else
	  (:not @file so its not something we can load/reload :)
	  (
	  <li><a href="{csd_webui:generateURL((concat('/CSD/SVS/RetrieveValueSet?ID=',$id)))}">Get {$id}</a></li>,
	  <li><form action="{csd_webui:generateURL(('/CSD/SVS/initSharedValueSet/svs',$id,'lookup'))}"><label for="code">Lookup Code</label><input name="code" type="text"/><input type="submit"/></form></li>
	  )
	  }
       </ul>

};





declare 
  %rest:path("/CSD/SVS/availSharedValueSet")
  %rest:GET
  %output:method("xhtml") 
  function page:svs_menu_avail() {
  

  let $sets :=   svs_lsvs:get_all_value_set_list()
  let $ids :=  $sets/svs:DescribedValueSet/@ID
  let $list := 
      <ul>
        {
	for $id in distinct-values($ids)
	where svs_lsvs:exists($id)
	order by $id
	return <li>
	         {$id}
	         <br/>
		 <ul>
		   {
		     for $set in  $sets//svs:DescribedValueSet[@ID = $id]
		     let $href := csd_webui:generateURL(( concat("/CSD/SVS/RetrieveValueSet?ID=", $id)))
		     let $version := string($set/@version)
		     order by $version
		     return <li><a href="{$href}"> {string($set/@displayName)}</a> version {$version}   </li>
		   }
		 </ul>
	       </li>
	}
     </ul>	
  return  csd_webui:wrapper($list)
};



