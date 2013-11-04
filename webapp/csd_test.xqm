module namespace page = 'http://basex.org/modules/web-page';
import module namespace csd = "urn:ihe:iti:csd:2013" at "../repo/csd_base_library.xqm";
import module namespace csr_proc = "https://github.com/his-interop/openinfoman/csr_proc" at "../repo/csr_processor.xqm";
import module namespace request = "http://exquery.org/ns/request";


declare
  %rest:path("/CSD/test/{$test}")
  %rest:GET
  function page:test(
    $test as xs:string)
{
let $test_doc := page:get_test_doc($test)
return if ($test_doc) then
 for $doc in collection('provider_directory')
 where matches(document-uri($doc), 'providers.xml')
 return csr_proc:process_CSR($test_doc/csd:careServicesRequest,$doc)
else
  <h2>Shame on you</h2>

};


declare
  %rest:path("/CSD/test_source/{$test}")
  %rest:GET
  %output:method("xml")
  function page:test_source(
    $test as xs:string)
{
let $test_doc := page:get_test_doc($test)
return if ($test_doc) then
 $test_doc
else
  <h2>Shame on you</h2>
};

declare function page:get_test_doc($test) {
let $dir_base := "../test_docs/"
let $dir := file:resolve-path($dir_base)
let $file := file:resolve-path(concat($dir_base,$test,".xml"))
return if (starts-with($file,$dir) and file:exists($file)) 
then
  doc($file)
else
  ()
};

declare 
  %rest:path("/CSD/test")
  %rest:GET
  %output:method("xhtml")
  function page:list_tests() 
{
<html>
  <head>
    <link href="http://{request:hostname()}:{request:port()}/static/bootstrap/css/bootstrap.css" rel="stylesheet"/>
    <link href="http://{request:hostname()}:{request:port()}/static/bootstrap/css/bootstrap-theme.css" rel="stylesheet"/>
  </head>
  <body>
    <div class="navbar navbar-inverse navbar-static-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="http://{request:hostname()}:{request:port()}/CSD">OpenInfoMan</a>
        </div>
      </div>
    </div>
    <div class='container'>
      <div class='row'>
	<h2>Tests</h2>
	<p>
	To test submission on your machine you can do:
	<pre>
	curl --form "fileupload=@test.xml" http://{request:hostname()}:{request:port()}/CSD/careServicesRequest
	</pre>
	where test.xml is one of the downloaded source documents below
	</p>
	<ul>
          {for $test_doc in file:list("../test_docs/",boolean('false'),"*.xml")
	  order by $test_doc
	  let $test := file:base-name($test_doc,".xml")
          return  <li>
	  {$test}:<a href="test/{$test}"> process on server</a>  /
	  <a href="test_source/{$test}"> download source</a> 
 	</li>
          }
	</ul>
      </div>
    </div>

  </body>
</html>
};


