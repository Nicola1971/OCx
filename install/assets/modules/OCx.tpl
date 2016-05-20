/**
 * OCx
 *
 * Open Cart DB credentials for OCx snippets
 * @author	Nicola Lambathakis
 * @category	module
 * @internal	@modx_category OCx
 * @internal	@properties &oc_db_hostname=db_hostname;string;localhost &oc_db_username=db_username;string;root &oc_db_password=db_password;string &oc_db_database=db_databas;string;opencart2 &oc_shop_url=shop_url;string;http://localhost/opencart2;
&oc_amazon=amazon;string;amazon.it &oc_affiliate_amazon_tag=amazon affiliate tag;string;yourtag-21
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 */

/* OCx module */
/*

&oc_db_hostname=db_hostname;string;localhost &oc_db_username=db_username;string;root &oc_db_password=db_password;string &oc_db_database=db_databas;string;opencart2 &oc_shop_url=shop_url;string;http://localhost/opencart2;
&oc_amazon=amazon;string;amazon.it &oc_affiliate_amazon_tag=amazon affiliate tag;string;ideeshop-21
*/
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

$db_server = new mysqli($db_hostname,$db_username,$db_password,$db_database);  
if (mysqli_connect_errno()) { 
    printf("Can't connect to MySQL Server. Errorcode: %s\n", mysqli_connect_error()); 
    exit; 
}
$moduleurl = 'index.php?a=112&id='.$_GET['id'].'&';


switch ($_GET['action']) {
    case 'getorders':
                $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
                $rows = isset($_POST['rows']) ? intval($_POST['rows']) : 10;
				$sort = isset($_POST['sort']) ? strval($_POST['sort']) : 'order_id';
				$order = isset($_POST['order']) ? strval($_POST['order']) : 'asc';
                $offset = ($page-1)*$rows;
                $result = array();
                       
                $rs = mysqli_query($db_server, "select count(*) from oc_order");
                $row = mysqli_fetch_row($rs);
				$result["total"] = $row[0];
                $rs = mysqli_query($db_server, "select * from oc_order order by $sort $order limit $offset,$rows");
               
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
				$order = isset($_POST['order']) ? strval($_POST['order']) : 'asc';
                $offset = ($page-1)*$rows;
                $result = array();
                       
                $rs = mysqli_query($db_server, "select count(distinct oc_product.product_id, oc_product.price, oc_product.model, oc_product.quantity, oc_product.viewed, oc_product.date_added, oc_product.date_modified, oc_product_description.name) from oc_product INNER JOIN oc_product_description ON oc_product.product_id=oc_product_description.product_id");
                $row = mysqli_fetch_row($rs);
				$result["total"] = $row[0];
                $rs = mysqli_query($db_server, "select distinct oc_product.product_id, oc_product.price, oc_product.model, oc_product.quantity, oc_product.viewed, oc_product.date_added, oc_product.date_modified, oc_product_description.name from oc_product INNER JOIN oc_product_description ON oc_product.product_id=oc_product_description.product_id order by $sort $order limit $offset,$rows");
               
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
                $offset = ($page-1)*$rows;
                $result = array();
                       
                       
                $rs = mysqli_query($db_server, "select count(*) from oc_category_description");
                $row = mysqli_fetch_row($rs);
				$result["total"] = $row[0];
                $rs = mysqli_query($db_server, "select * from oc_category_description order by $sort $order limit $offset,$rows");
               
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
        <title>OCX</title>
		        <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/themes/bootstrap/easyui.css">
        <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/themes/bootstrap/datagrid.css">
	   <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/themes/bootstrap/tabs.css">
	        <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/demo/demo.css">
	 <link rel="stylesheet" type="text/css" href="media/style/<?php echo $theme?>/style.css" />

        <style type="text/css">
                #fm{
                        margin:0;
                        padding:10px 30px;
                }
                .ftitle{
                        font-size:14px;
                        font-weight:bold;
                        color:#666;
                        padding:5px 0;
                        margin-bottom:10px;
                        border-bottom:1px solid #ccc;
                }
                .fitem{
                        margin-bottom:5px;
                }
                .fitem label{
                        display:inline-block;
                        width:80px;
                }
        </style>
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="http://www.jeasyui.com/easyui/jquery.easyui.min.js"></script>
</head>
        <body style="padding:20px">
               <h1>OCx Opencart Module - Dashboard</h1>
                

 
			
			<div id="tt" class="easyui-tabs" style="width:100%;height:100%x;">
    <div title="Orders" style="padding:10px 0 0 0;display:none;">
     <table id="dg"  class="easyui-datagrid"
                        url="<?php echo $moduleurl.'action=getorders'; ?>"
                        toolbar="#toolbar" pagination="true"
                        rownumbers="true" fitColumns="true" singleSelect="true">
                <thead>
                        <tr>
                            <th sortable="true" field="order_id" width="auto">order id</th>   
							<th sortable="true" field="firstname" width="auto">firstname</th>
                                      <th sortable="true" field="lastname" width="auto">lastname</th>
                                <th sortable="true" field="email" width="auto">email</th>
                                <th sortable="true" field="telephone" width="auto">telephone</th>
                                      <th sortable="true" field="fax" width="auto">fax</th>
                                    <th sortable="true" field="total" width="auto">total</th>
                                <th sortable="true" field="currency_code" width="auto">currency</th>
                                      <th sortable="true" field="order_status_id" width="auto">status</th>
                                     <th sortable="true" field="date_added" width="auto">date added</th>
                                     <th sortable="true" field="date_modified" width="auto">date modified</th>
                        </tr>
                </thead>
        </table>
    </div>
    <div title="Products" data-options="closable:false" style="overflow:auto;padding:10px 0 0 0;display:none;">
		        
		
        <table id="pg"  class="easyui-datagrid"
                        url="<?php echo $moduleurl.'action=getproducts'; ?>"
                        toolbar="#toolbar" pagination="true"
                        rownumbers="true" fitColumns="true" singleSelect="true">
                <thead>
                        <tr>
                            <th sortable="true"field="product_id" width="auto">product id</th>   
							<th sortable="true"field="name" width="auto">name</th>
							<th sortable="true"field="model" width="auto">model</th>
                                <th sortable="true" field="price" width="auto">price</th>
                                <th sortable="true" field="quantity" width="auto">quantity</th>
                                     <th sortable="true" field="date_added" width="auto">date added</th>
                                     <th sortable="true" field="date_modified" width="auto">date modified</th>
                        </tr>
                </thead>
        </table>
    </div>
    <div title="Categories" data-options="closable:false" style="overflow:auto;padding:10px 0 0 0;display:none;">
<table id="cg"  class="easyui-datagrid"
                        url="<?php echo $moduleurl.'action=getcategories'; ?>"
                        toolbar="#toolbar" pagination="true"
                        rownumbers="true" fitColumns="true" singleSelect="true">
                <thead>
                        <tr>
                            <th sortable="true"field="category_id" width="auto">category id</th>   
							<th sortable="true"field="name" width="20">name</th>
                        </tr>
                </thead>
        </table>
    </div>
</div>
			
</body>
</html>
<?php     
}        
