<?php

/**
 * OCx
 *
 * OCx 1.8 Module - Open Cart Dashboard
 * @author	Nicola Lambathakis
 * @category	module
 * @internal	@modx_category OCx
 * @internal	@properties &oc_db_hostname=db_hostname;string;localhost &oc_db_username=db_username;string;root &oc_db_password=db_password;string &oc_db_database=db_databas;string;opencart2 &oc_shop_url= Opencart url;string;http://localhost/opencart2 &oc_image_folder=Opencart images folder;string;image/ &oc_show_images=Show products images;list;remote,local;remote &oc_shop_lang=shop language ID;string;1 &oc_amazon=amazon;string;amazon.it &oc_affiliate_amazon_tag=amazon affiliate tag;string;yourtag-21
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 */

/* OCx module */
/*
&oc_db_hostname=db_hostname;string;localhost &oc_db_username=db_username;string;root &oc_db_password=db_password;string &oc_db_database=db_databas;string;opencart2 &oc_shop_url= Opencart url;string;http://localhost/opencart2 &oc_image_folder=Opencart images folder;string;image/ &oc_show_images=Show products images;list;remote,local;remote &oc_shop_lang=shop language ID;string;1 &oc_amazon=amazon;string;amazon.it &oc_affiliate_amazon_tag=amazon affiliate tag;string;yourtag-21
 * */

if (!defined('IN_MANAGER_MODE') || (defined('IN_MANAGER_MODE') && (!IN_MANAGER_MODE || IN_MANAGER_MODE == 'false'))) die();

global $modx;
global $manager_theme;
$theme = $modx->config['manager_theme'];

if (!isset($oc_db_hostname)) {
    echo "Please set configuration";
    return false;
}

$db_hostname = $oc_db_hostname;
$db_username = $oc_db_username;
$db_password = $oc_db_password;
$db_database = $oc_db_database;
$shop_url= $oc_shop_url;
$image_folder= $oc_image_folder;
$shop_lang = $oc_shop_lang;
$show_images = $oc_show_images;

$test = "test";

$moduleurl = 'index.php?a=112&id='.$_GET['id'].'&';

// module info
$module_version = '1.8';
$module_id = (!empty($_REQUEST["id"])) ? (int)$_REQUEST["id"] : $yourModuleId;
$mods_path = $modx->config['base_path'] . "assets/modules/";

$_lang = array();
include($mods_path.'ocx/lang/english.php');
if (file_exists($mods_path.'ocx/lang/' . $modx->config['manager_language'] . '.php')) {
    include($mods_path.'ocx/lang/' . $modx->config['manager_language'] . '.php');
}

$db_server = new mysqli($db_hostname,$db_username,$db_password,$db_database);  
mysqli_set_charset($db_server, "utf8");
if (mysqli_connect_errno()) { 
    printf("Can't connect to MySQL Server - Please check Module configuration. Errorcode: %s\n", mysqli_connect_error()); 
    exit; 
}
/**************************************/

 //first get the base name of the image
    $i_name = explode('.', basename($img_url));
    $i_name = $i_name[0];
	
		    //second get the dir name of the image
    $i_path = explode('.', dirname($img_url));
    $i_path = $i_path[0];
	$subfolders = explode('/', $i_path);
	
	$urlparts = parse_url($img_url);
$remotepath = $urlparts['path'].'?'.$urlparts['query'];



if(remote == $show_images)	{
$oc_img_path = $shop_url . "/" . $image_folder;
}	

if(local == $show_images)	{
$oc_img_path = "../assets/images/" . $subfolders[5] . "/" . $subfolders[6] . "/";
}
if(no == $show_images)	{
$oc_img_path = "../assets/modules/ocx/images/noimage.png' height='42' width='42'>";

}	
/******************************************************************/



$rsproduct = mysqli_query($db_server, "select distinct oc_product.product_id, oc_product.status, oc_product.image, oc_product.price, oc_product.model, oc_product.quantity, oc_product.viewed, oc_product.date_added, oc_product.date_modified, oc_product_description.name from oc_product INNER JOIN oc_product_description ON oc_product.product_id=oc_product_description.product_id");
               //$downloadProductImage = itg_fetch_image('+row_image+');
while( $row = $modx->db->getRow( $rsproduct ) ) {  
$ProductsTable .= '<tr>
<td>' . $row['image']. '</td>
<td>' . $row['product_id']. '</td> 
<td>' . $row['name']. '</td>  
<td>' . $row['model']. '</td>
<td>' . $row['price'] . '  </td>
<td>' . $row['quantity'] . '  </td>
<td>' . $row['date_added'] . '  </td>
<td>' . $row['date_modified'] . '  </td>
<td align="right">   
</td>
<td align="right">   
</td>
</tr>';    
}

$rscategory = mysqli_query($db_server, "select * from oc_category_description group by category_id");

while( $row = $modx->db->getRow( $rscategory ) ) {  
$CategoriesTable .= '<tr>
<td style="width:5%">' . $row['category_id']. '</td>
<td>' . $row['name']. '</td> 
<td></td> 
</tr>';    
}

$rsorders = mysqli_query($db_server, "select distinct oc_order.order_id, oc_order.firstname, oc_order.lastname, oc_order.email, oc_order.telephone, oc_order.fax, oc_order.total, oc_order.payment_method, oc_order.currency_code, oc_order.payment_address_1, oc_order.payment_city, oc_order.payment_postcode, oc_order.payment_country, oc_order_status.order_status_id, oc_order.date_added, oc_order.date_modified, oc_order_status.name from oc_order INNER JOIN oc_order_status ON oc_order.order_status_id=oc_order_status.order_status_id group by order_id");

while( $row = $modx->db->getRow( $rsorders ) ) {  
$OrdersTable .= '<tr>
<td>' . $row['order_id']. '</td>
<td>' . $row['date_added']. '</td> 
<td>' . $row['name']. '</td>  
<td>' . $row['total']. '</td>
<td>' . $row['currency_code'] . '  </td>
<td>' . $row['payment_method'] . '  </td>
<td>' . $row['firstname'] . '  </td>
<td>' . $row['lastname'] . '  </td>

<td>' . $row['email']. '</td>  
<td>' . $row['telephone']. '</td>
<td>' . $row['payment_address_1'] . '  </td>
<td>' . $row['payment_city'] . '  </td>
<td>' . $row['payment_postcode'] . '  </td>
</tr>';    
}

$rscustomers = mysqli_query($db_server, "select * from oc_customer");

while( $row = $modx->db->getRow( $rscustomers ) ) {  
$CustomersTable .= '<tr>
<td>' . $row['customer_id']. '</td>
<td>' . $row['firstname']. '</td> 
<td>' . $row['lastname']. '</td>  
<td>' . $row['email']. '</td>
<td>' . $row['telephone'] . '  </td>
<td>' . $row['date_added'] . '  </td>
<td>' . $row['ip'] . '  </td>
</tr>';    
}

$ModuleOutput = '
<!DOCTYPE html>
<html>
<head>
<title>OCx Module</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="media/script/jquery/jquery.min.js"></script>
<script src="media/script/bootstrap/js/bootstrap.min.js"></script>
<script src="../assets/modules/ocx/bootgrid/jquery.bootgrid.min.js"></script>
<script src="../assets/modules/ocx/bootgrid/jquery.bootgrid.fa.min.js"></script>
<link rel="stylesheet" type="text/css" href="media/style/common/bootstrap/css/bootstrap.min.css" />
<link rel="stylesheet" href="media/style/common/font-awesome/css/font-awesome.min.css" />
<link rel="stylesheet" href="../assets/modules/ocx/bootgrid/jquery.bootgrid.min.css" />
<link rel="stylesheet" type="text/css" href="media/style/'.$theme.'/style.css" />
<script type="text/javascript" src="media/script/tabpane.js"></script>
<script>
$(document).ready(function(e) {
        $(document).delegate(\'textarea\', \'focus click\', function(e) {
        var myText = $(this);
        var mytxt = myText.text();
        myText.select();
        e.stopImmediatePropagation(); 
        $(\'#igot\').text(mytxt+e.type);
        return false;
    });
})

 function hideLoader() {
 document.getElementById(\'preLoader\').style.display = "none";
}
hideL = window.setTimeout("hideLoader()", 1500);
</script>
<script>
jQuery(document).ready(function ($) {
  $(".ocx-datagrid").bootgrid({
    selection: true,
    multiSelect: true,
    rowSelect: true,
    keepSelection: true,
        labels: {
        search: "'.$_lang['search'].'",
        all: "'.$_lang['all'].'",
        infos: "'.$_lang['infos'].'"
    },
    formatters: {
            "code1": function(column, row)
        {
            return "<textarea rows=\"4\" cols=\"30\">[[OCxProduct? &id=`" + row.product_id + "` &opencartTpl=`opencartTpl` &fetchimages=`1` &store_dir=`assets/images/ocx`]]</textarea>";
        },
            "code2": function(column, row)
        {
            return "<textarea rows=\"4\" cols=\"40\">[[OCxCategory? &cat=`" + row.category_id + "` &opencartTpl=`opencartTpl` &limit=`50` &fetchimages=`1` &orderby=`price` &store_dir=`assets/images/ocx` &orderdir=`DESC` ]]</textarea>";
        },
        "imageCol": function(column, row)
        {
            return "<a target=\"_blank\" href=\"'.$oc_img_path . '" + row.image + "\"><img src=\"'.$oc_img_path . '" + row.image + "\" height=\"45\" width=\"45\"></a>";
        },
		 "viewproduct": function(column, row)
        {
            return "<a target=\"_blank\" class=\"btn btn-sm btn-default command-edit\" data-row-id=\"" + row.id + "\" href=\"'.$shop_url.'/index.php?route=product/product&product_id=" + row.product_id + "\"><span class=\"fa fa-eye\"></span></a> ";
        },
    		 "viewcat": function(column, row)
        {
            return "<a target=\"_blank\" class=\"btn btn-sm btn-default command-edit\" data-row-id=\"" + row.id + "\" href=\"'.$shop_url.'/index.php?route=product/category&path=" + row.category_id + "\"><span class=\"fa fa-eye\"></span></a> ";
        }
    }
    });
});
</script>
<style>
.firstColumn {width:100px}
.codeColumn {min-width:350px!important}
.codeColumn2 {min-width:350px; margin-right:3px;}
textarea {font-size:11px; border:dotted 1px #3697CD;}
.actionBar li {list-style-type: none; list-style-image:none;}
</style>
</head>
<body>
<div id="preLoader"><table width="100%" border="0" cellpadding="0"><tr><td align="center">
    <div class="preLoaderText" style="width:450px;height:300px">
<h1 class="pagetitle">
  <span class="pagetitle-icon">
     <span class="fa-stack fa-lg fa-pulse">
  <i class="fa fa-circle fa-stack-2x"></i>
  <i class="fa fa-opencart fa-stack-1x fa-inverse"></i>
</span>
  </span>
  <span class="pagetitle-text">
 OCx Opencart 
  </span>
</h1>
<p>
'.$_lang["loading_data"].'<br/>'.$_lang["wait"].'               
</p>
</div>
    </td>
    </tr>
    </table>
</div> 
           
<h1 class="pagetitle">
  <span class="pagetitle-icon">
    <i class="fa fa-opencart"></i>
  </span>
  <span class="pagetitle-text">
  '.$_lang['modulename'].' '.$_lang['OpencartModule'].'  - '.$_lang['Dashboard'].' 
  </span>
</h1>          
<div id="actions">
    <ul class="actionButtons">
    <!--@IF:[[#hasPermission?key=new_module]] OR [[#hasPermission?key=edit_module]]-->
    <li id="Button6"><a href="index.php?a=108&id='.$module_id.'"><i class="fa fa-cog"></i> '.$_lang['Config'].' </a> </li>
    <!--@ENDIF-->
     <li id="Button9"><a target="_blank" href="'.$shop_url.'" class=""><i class="fa fa-opencart"></i> '.$_lang['opencart'].' </a></li>
        <li id="Button5"><a href="index.php?a=2">
            '.$_lang['close'].'
        </a></li>
    </ul>
</div>

<div class="sectionBody">    
<div class="tab-pane" id="tab-pane-ocx"> 
<!--- tab-page --->
<div class="tab-page">
<h2 class="tab"><i class="fa fa-gift"></i> '.$_lang['Products'].'</h2>		
<table id="Products"  class="ocx-datagrid table table-hover table-bordered table-striped">
<thead>
<tr>
<th data-column-id="image" data-header-css-class="firstColumn" data-formatter="imageCol" style="width=50px">'.$_lang['image'].'</th> 
<th data-column-id="product_id" data-header-css-class="firstColumn">'.$_lang['product_id'].'</th>                    
<th data-column-id="name">'.$_lang['name'].'</th>
<th data-column-id="model">'.$_lang['model'].'</th>
<th data-column-id="price">'.$_lang['price'].'</th>
<th data-column-id="quantity" data-visible="false" >'.$_lang['quantity'].'</th>
<th data-column-id="date_added" data-visible="true" >'.$_lang['date_added'].'</th>
<th data-column-id="date_modified" data-visible="false" >'.$_lang['date_modified'].'</th>
<th data-column-id="code" data-formatter="code1" data-visible="true" data-header-css-class="codeColumn">'.$_lang['snippet_call'].'</th>
<th data-column-id="commands" data-formatter="viewproduct" data-sortable="false" data-header-css-class="firstColumn">'.$_lang['view'].'</th>

</tr>
</thead>
<tbody>'.$ProductsTable.'</tbody>
</table>
</div>
<!--- #end tab-page --->

<!--- tab-page --->
<div class="tab-page">
<h2 class="tab"><i class="fa fa-folder-open"></i> '.$_lang['Categories'].'</h2>		
<table id="Categories"  class="ocx-datagrid table table-hover table-bordered table-striped">
<thead>
<tr>
<th data-column-id="category_id" data-header-css-class="firstColumn">'.$_lang['category_id'].'</th>                  
<th data-column-id="name">'.$_lang['name'].'</th>
<th data-column-id="code" data-formatter="code2" data-sortable="code" data-visible="true" data-header-css-class="codeColumn2">'.$_lang['snippet_call'].'</th>
<th data-column-id="commands" data-formatter="viewcat" data-sortable="false" data-header-css-class="firstColumn">'.$_lang['view'].'</th>
</thead>
<tbody>'.$CategoriesTable.'</tbody>
</table>
</div>
<!--- #end tab-page --->

<!--- tab-page --->
<div class="tab-page">
<h2 class="tab"><i class="fa fa-shopping-cart"></i> '.$_lang['Orders'].'</h2>		
<table id="Orders"  class="ocx-datagrid table table-hover table-bordered table-striped">
<thead>
<tr>
<th data-column-id="order_id" data-header-css-class="firstColumn">'.$_lang['order_id'].'</th>                    
<th data-column-id="date_added">'.$_lang['date_added'].'</th>
<th data-column-id="name">'.$_lang['status'].'</th>
<th data-column-id="total">'.$_lang['total'].'</th>
<th data-column-id="currency_code">'.$_lang['currency'].'</th>
<th data-column-id="method">'.$_lang['method'].'</th>
<th data-column-id="firstname">'.$_lang['firstname'].'</th>
<th data-column-id="lastname">'.$_lang['lastname'].'</th>                    
<th data-column-id="email">'.$_lang['email'].'</th>
<th data-column-id="telephone">'.$_lang['telephone'].'</th>
<th data-column-id="payment_address_1">'.$_lang['address'].'</th>
<th data-column-id="payment_city">'.$_lang['city'].'</th>
<th data-column-id="payment_postcode">'.$_lang['postcode'].'</th>

</tr>
</thead>
<tbody>'.$OrdersTable.'</tbody>
</table>
</div>
<!--- #end tab-page --->

<!--- tab-page --->
<div class="tab-page">
<h2 class="tab"><i class="fa fa-user"></i> '.$_lang['Customers'].'</h2>		
<table id="Customers"  class="ocx-datagrid table table-hover table-bordered table-striped">
<thead>
<tr>
<th data-column-id="customer_id" data-header-css-class="firstColumn">'.$_lang['customer_id'].'</th>                    
<th data-column-id="firstname">'.$_lang['firstname'].'</th>
<th data-column-id="lastname">'.$_lang['lastname'].'</th>
<th data-column-id="email">'.$_lang['email'].'</th>
<th data-column-id="telephone">'.$_lang['telephone'].'</th>
<th data-column-id="date_added">'.$_lang['date_added'].'</th>
<th data-column-id="ip">'.$_lang['ip'].'</th>
</tr>
</thead>
<tbody>'.$CustomersTable.'</tbody>
</table>
</div>
<!--- #end tab-page --->
<div class="ocxfooter">	
<div style="float:right; padding:5px 5px 0 0">OCx '.$module_version.'</div>
<div style="float:left; padding:5px 0 0 5px">'.$_lang['Connection_Info'].':<a target="_blank" href="'.$shop_url.'"> '.$shop_url.'</a></div>
</div>
 
</div>
<!--- #end all tab-pane --->

</div>
<!--- #end sectionbody --->
</body>
</html>';

//end module
$output = $ModuleOutput;
echo $output;        
