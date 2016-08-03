<?php

/**
 * OCx
 *
 * OCx 1.7.4 Module - Open Cart Dashboard
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
global $modx;
if (!defined('IN_MANAGER_MODE') || (defined('IN_MANAGER_MODE') && (!IN_MANAGER_MODE || IN_MANAGER_MODE == 'false'))) die();
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



$moduleurl = 'index.php?a=112&id='.$_GET['id'].'&';

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
$oc_img_path = $shop_url . "/" . $image_folder . "/";
}	

if(local == $show_images)	{
$oc_img_path = "../assets/images/" . $subfolders[5] . "/" . $subfolders[6] . "/";
}
if(no == $show_images)	{
$oc_img_path = "../assets/modules/ocx/images/noimage.png' height='42' width='42'>";

}	
/******************************************************************/
switch ($_GET['action']) {
    case 'getorders':
                $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
                $rows = isset($_POST['rows']) ? intval($_POST['rows']) : 10;
				$sort = isset($_POST['sort']) ? strval($_POST['sort']) : 'order_id';
				$order = isset($_POST['order']) ? strval($_POST['order']) : 'desc';
				$order_id = isset($db_server, $_POST['order_id']) ? mysqli_real_escape_string($db_server, $_POST['order_id']) : '';
				$email = isset($db_server, $_POST['email']) ? mysqli_real_escape_string($db_server, $_POST['email']) : '';
                $offset = ($page-1)*$rows;
                $result = array();
                $where = "oc_order.order_id like '$order_id%' and oc_order.email like '$email%' and oc_order_status.language_id='$shop_lang'";       
                $rs = mysqli_query($db_server, "select count(distinct oc_order.order_id, oc_order.firstname, oc_order.lastname, oc_order.email, oc_order.telephone, oc_order.fax, oc_order.total, oc_order.payment_method, oc_order.currency_code, oc_order.payment_address_1, oc_order.payment_city, oc_order.payment_postcode, oc_order.payment_country, oc_order_status.order_status_id, oc_order.date_added, oc_order.date_modified, oc_order_status.name) from oc_order INNER JOIN oc_order_status ON oc_order.order_status_id=oc_order_status.order_status_id  where " . $where);
                $row = mysqli_fetch_row($rs);
				$result["total"] = $row[0];
                $rs = mysqli_query($db_server, "select distinct oc_order.order_id, oc_order.firstname, oc_order.lastname, oc_order.email, oc_order.telephone, oc_order.fax, oc_order.total, oc_order.payment_method, oc_order.currency_code, oc_order.payment_address_1, oc_order.payment_city, oc_order.payment_postcode, oc_order.payment_country, oc_order_status.order_status_id, oc_order.date_added, oc_order.date_modified, oc_order_status.name from oc_order INNER JOIN oc_order_status ON oc_order.order_status_id=oc_order_status.order_status_id  where  " . $where . " order by $sort $order limit $offset,$rows");
                $items = array();
                while($row = mysqli_fetch_array($rs)){
                        array_push($items, $row);
                }
                $result["rows"] = $items;
                echo json_encode($result);
    break;
	

    case 'getproducts':	
                $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
                $rows = isset($_POST['rows']) ? intval($_POST['rows']) : 10;
				$sort = isset($_POST['sort']) ? strval($_POST['sort']) : 'product_id';
				$order = isset($_POST['order']) ? strval($_POST['order']) : 'desc';
				$product_id = isset($db_server, $_POST['product_id']) ? mysqli_real_escape_string($db_server, $_POST['product_id']) : '';
				$name = isset($db_server, $_POST['name']) ? mysqli_real_escape_string($db_server, $_POST['name']) : '';
                $offset = ($page-1)*$rows;
                $result = array();
                $where = "oc_product.product_id like '$product_id%' and oc_product_description.name like '$name%' and oc_product.status=1";       
                $rs = mysqli_query($db_server, "select count(distinct oc_product.product_id, oc_product.status, oc_product.image, oc_product.price, oc_product.model, oc_product.quantity, oc_product.viewed, oc_product.date_added, oc_product.date_modified, oc_product_description.name) from oc_product INNER JOIN oc_product_description ON oc_product.product_id=oc_product_description.product_id where " . $where);
                $row = mysqli_fetch_row($rs);
				$result["total"] = $row[0];
                $rs = mysqli_query($db_server, "select distinct oc_product.product_id, oc_product.status, oc_product.image, oc_product.price, oc_product.model, oc_product.quantity, oc_product.viewed, oc_product.date_added, oc_product.date_modified, oc_product_description.name from oc_product INNER JOIN oc_product_description ON oc_product.product_id=oc_product_description.product_id where  " . $where . " order by $sort $order limit $offset,$rows");
               //$downloadProductImage = itg_fetch_image('+row_image+');
                $items = array();
                while($row = mysqli_fetch_array($rs)){
                        array_push($items, $row);
                }
                $result["rows"] = $items;

                echo json_encode($result);
	                
    break;

    case 'getcategories':	
                $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
                $rows = isset($_POST['rows']) ? intval($_POST['rows']) : 10;
				$sort = isset($_POST['sort']) ? strval($_POST['sort']) : 'category_id';
				$order = isset($_POST['order']) ? strval($_POST['order']) : 'asc';
				$category_id = isset($db_server, $_POST['category_id']) ? mysqli_real_escape_string($db_server, $_POST['category_id']) : '';
				$cname = isset($db_server, $_POST['cname']) ? mysqli_real_escape_string($db_server, $_POST['cname']) : '';
                $offset = ($page-1)*$rows;
                $result = array();
                $where = "oc_category_description.category_id like '$category_id%' and oc_category_description.name like '$cname%'";       
                       
                $rs = mysqli_query($db_server, "select count(*) from oc_category_description where " . $where);
                $row = mysqli_fetch_row($rs);
				$result["total"] = $row[0];
                $rs = mysqli_query($db_server, "select * from oc_category_description where " . $where . "  group by category_id order by $sort $order limit $offset,$rows");
               
                $items = array();
                while($row = mysqli_fetch_array($rs)){
                        array_push($items, $row);
                }
                $result["rows"] = $items;

                echo json_encode($result);
	
    break;
	
	    case 'getcustomer':
                $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
                $rows = isset($_POST['rows']) ? intval($_POST['rows']) : 10;
				$sort = isset($_POST['sort']) ? strval($_POST['sort']) : 'customer_id';
				$order = isset($_POST['order']) ? strval($_POST['order']) : 'desc';
				$firstname = isset($db_server, $_POST['firstname']) ? mysqli_real_escape_string($db_server, $_POST['firstname']) : '';
				$lastname = isset($db_server, $_POST['lastname']) ? mysqli_real_escape_string($db_server, $_POST['lastname']) : '';
                $offset = ($page-1)*$rows;
                $result = array();
                $where = "oc_customer.firstname like '$firstname%' and oc_customer.lastname like '$lastname%'";       
                $rs = mysqli_query($db_server, "select count(*) from oc_customer where " . $where);
                $row = mysqli_fetch_row($rs);
				$result["total"] = $row[0];
                $rs = mysqli_query($db_server, "select * from oc_customer where " . $where . " order by $sort $order limit $offset,$rows");
               
                $items = array();
                while($row = mysqli_fetch_array($rs)){
                        array_push($items, $row);
                }
                $result["rows"] = $items;

                echo json_encode($result);
    break;
    default:
?>
<!DOCTYPE html>
<html>
<head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="keywords" content="jquery,ui,easy,easyui,web">
        <meta name="description" content="easyui help you build your web page easily!">
        <title>OCx Module</title>
	
        <link rel="stylesheet" type="text/css" href="../assets/modules/ocx/easyui/themes/datagrid.css">
	    <link rel="stylesheet" type="text/css" href="../assets/modules/ocx/easyui/themes/tabs.css">
	    <link rel="stylesheet" type="text/css" href="../assets/modules/ocx/easyui/themes/icon.css">
         <link rel="stylesheet" type="text/css" href="../assets/modules/ocx/easyui/themes/ocx.css">
                  <link rel="stylesheet" type="text/css" href="../assets/modules/ocx/font-awesome/css/font-awesome.min.css">
	    <link rel="stylesheet" type="text/css" href="media/style/<?php echo $theme;?>/style.css" />
 
       
        <script type="text/javascript" src="../assets/modules/ocx/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="../assets/modules/ocx/easyui/jquery.easyui.min.js"></script>
        
    
	<script>
		function doSearch(){
    $('#gor').datagrid('load',{
        order_id: $('#order_id').val(),
        email: $('#email').val()
    });
}
	</script>
		<script>
		function doSearch2(){
    $('#gpr').datagrid('load',{
        product_id: $('#product_id').val(),
        name: $('#name').val()
    });
}
	</script>
    

		<script>
		function doSearch3(){
    $('#gca').datagrid('load',{
        category_id: $('#category_id').val(),
        cname: $('#cname').val()
    });
}
	</script>
	<script>
		function doSearch4(){
    $('#gcu').datagrid('load',{
        firstname: $('#firstname').val(),
        lastname: $('#lastname').val()
    });
}
	</script>
   <script>
    function formatImage(val,row){
    return '<img src="<?php echo $oc_img_path;?>'+val+'" height="43" width="43">';
}

</script>
    <script>
    function formatUrl(val,row){
    var href = '<?php echo $shop_url;?>/index.php?route=product/product&product_id='+row.product_id;
    return '<a class="easyui-viewbutton" target="_blank" href="' + href + '"><i class="fa fa-eye" aria-hidden="true"></i></a></li></ul>';
}

</script>


</head>
        <body style="padding:20px">
               <h1>OCx Opencart Module - Dashboard</h1>
			<div class="right">Connected to your shop at:<a target="_blank" href="<?php echo $shop_url;?>"> <?php echo $shop_url;?></a></div>	
 <div class="sectionBody">                

 
			
			<div id="tt" class="easyui-tabs" style="width:100%;height:100%x;">
    
    <div title="Products" data-options="closable:false" style="overflow:auto;padding:10px 0 0 0;display:none;">
	<div id="toolbar2" style="padding:3px">
    <span>Product ID:</span>
    <input id="product_id" style="line-height:26px;border:1px solid #ccc">
    <span>Name:</span>
    <input id="name" style="line-height:26px;border:1px solid #ccc">
    <a href="#" class="easyui-linkbutton" plain="true" onclick="doSearch2()"><i class="fa fa-search" aria-hidden="true"></i> Search</a>
</div>	        
		
        <table id="gpr"  class="easyui-datagrid"
                        url="<?php echo $moduleurl.'action=getproducts'; ?>"
                        toolbar="#toolbar2" pagination="true"
                        rownumbers="false" fitColumns="true" singleSelect="true">
                <thead>
                        <tr>
                        <th field="image" formatter="formatImage" width="auto">image</th> 
                        <th sortable="true" field="product_id" width="auto">product id</th>                    
                       	<th sortable="true" field="name" width="auto">name</th>
							<th sortable="true"field="model" width="auto">model</th>
                                <th sortable="true" field="price" width="auto">price</th>
                                <th sortable="true" field="quantity" width="auto">quantity</th>
                                     <th sortable="true" field="date_added" width="auto">date added</th>
                                     <th sortable="true" field="date_modified" width="auto">date modified</th>
                                      <th field="dw" formatter="formatUrl" width="auto">view</th>
          
                        </tr>
                </thead>
        </table>
    </div>
    <div title="Categories" data-options="closable:false" style="overflow:auto;padding:10px 0 0 0;display:none;">
<div id="toolbar3" style="padding:3px">
    <span>Category ID:</span>
    <input id="category_id" style="line-height:26px;border:1px solid #ccc">
    <span>Name:</span>
    <input id="cname" style="line-height:26px;border:1px solid #ccc">
    <a href="#" class="easyui-linkbutton" plain="true" onclick="doSearch3()">Search</a>
</div>	        
<table id="gca"  class="easyui-datagrid"
                        url="<?php echo $moduleurl.'action=getcategories'; ?>"
                        toolbar="#toolbar3" pagination="true"
                        rownumbers="true" fitColumns="true" singleSelect="true">
                <thead>
                        <tr>
                            <th sortable="true"field="category_id" width="auto">category id</th>   
							<th sortable="true"field="name" width="20">name</th>
                        </tr>
                </thead>
        </table>
    </div>
<div title="Orders" style="padding:10px 0 0 0;display:none;">
		
				<div id="#toolbar1" style="padding:3px">
	    <span>Order ID:</span>
    <input id="order_id" style="line-height:26px;border:1px solid #ccc">
    <span>email:</span>
    <input id="email" style="line-height:26px;border:1px solid #ccc">

    <a href="#" class="easyui-linkbutton" plain="true" onclick="doSearch()">Search</a>
</div>
		
     <table id="gor"  class="easyui-datagrid"
                        url="<?php echo $moduleurl.'action=getorders'; ?>"
                        toolbar="#toolbar1" pagination="true"
                        rownumbers="true" fitColumns="true" singleSelect="true">
                <thead>
                        <tr>
                                    <th sortable="true" field="order_id" width="auto">order id</th> 
                                     <th sortable="true" field="date_added" width="auto">date added</th>  
                                     <th sortable="true" field="name" width="auto">status</th>
                                     <th sortable="true" field="total" width="auto">total</th>
                                <th sortable="true" field="currency_code" width="auto">currency</th>
							 <th sortable="true" field="payment_method" width="auto">method</th>
                                    <th sortable="true" field="firstname" width="auto">firstname</th>
                                     <th sortable="true" field="lastname" width="auto">lastname</th>                      

                                     <th sortable="true" field="email" width="auto">email</th>
                                      <th sortable="true" field="telephone" width="auto">telephone</th>
							         <th sortable="true" field="payment_address_1" width="auto">address</th>
                                     <th sortable="true" field="payment_city" width="auto">city</th>
                                     <th sortable="true" field="payment_postcode" width="auto">postcode</th>
                        </tr>
                </thead>
        </table>
    </div>
<div title="Customers" data-options="closable:false" style="overflow:auto;padding:10px 0 0 0;display:none;">
<div id="toolbar4" style="padding:3px">
    <span>firstname:</span>
    <input id="firstname" style="line-height:26px;border:1px solid #ccc">
    <span>lastname:</span>
    <input id="lastname" style="line-height:26px;border:1px solid #ccc">
    <a href="#" class="easyui-linkbutton" plain="true" onclick="doSearch4()">Search</a>
</div>	        
<table id="gcu"  class="easyui-datagrid"
                        url="<?php echo $moduleurl.'action=getcustomer'; ?>"
                        toolbar="#toolbar4" pagination="true"
                        rownumbers="true" fitColumns="true" singleSelect="true">
                <thead>
                        <tr>
                            <th sortable="true"field="customer_id" width="auto">customer id</th>   
							<th sortable="true"field="firstname" width="auto">firstname</th>
							<th sortable="true"field="lastname" width="auto">lastname</th>
							<th sortable="true"field="email" width="auto">email</th>
							<th sortable="true"field="telephone" width="auto">telephone</th>
							<th sortable="true" field="date_added" width="auto">date added</th>
							<th sortable="true" field="ip" width="auto">ip</th>
                        </tr>
                </thead>
        </table>
    </div>
</div>
<div>	
<div style="float:right">OCx 1.7.4 </div>	
</div>							
</div>
	
</body>
</html>
<?php     
}        
