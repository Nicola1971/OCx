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
 
/* OCX module */
/*

&oc_db_hostname=db_hostname;string;localhost &oc_db_username=db_username;string;root &oc_db_password=db_password;string &oc_db_database=db_databas;string;opencart2 &oc_shop_url=shop_url;string;http://localhost/opencart2;
&oc_amazon=amazon;string;amazon.it &oc_affiliate_amazon_tag=amazon affiliate tag;string;ideeshop-21
*/
if (!isset($oc_db_hostname)) {
    echo "Please set module configuration";
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

//$ds = $db->select('*','table_name');
switch ($_GET['action']) {
    case 'get':
                $page = isset($_POST['page']) ? intval($_POST['page']) : 1;
                $rows = isset($_POST['rows']) ? intval($_POST['rows']) : 10;
                $offset = ($page-1)*$rows;
                $result = array();
                       
                $count = mysqli_query($db_server, "select count(*) from oc_order");
                $result["total"] = $count;
                $rs = mysqli_query($db_server, "select * from oc_order limit $offset,$rows");
               
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
        <title>OCx Opencart Module</title>
	        <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/themes/bootstrap/easyui.css">
        <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/themes/bootstrap/datagrid.css">
	   <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/themes/bootstrap/tabs.css">
	        <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="http://www.jeasyui.com/easyui/demo/demo.css">
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
               <h2>OCx Opencart Module - Orders</h2>
                <table id="dg"  class="easyui-datagrid"
                        url="<?php echo $moduleurl.'action=get'; ?>"
                        toolbar="#toolbar" pagination="true"
                        rownumbers="true" fitColumns="true" singleSelect="true">
                <thead>
                        <tr>
                            <th field="order_id" width="auto">oirder id</th>   
							<th field="firstname" width="auto">firstname</th>
                                      <th field="lastname" width="auto">lastname</th>
                                <th field="email" width="auto">email</th>
                                <th field="telephone" width="auto">telephone</th>
                                      <th field="fax" width="auto">fax</th>
                                    <th field="total" width="auto">total</th>
                                <th field="currency_code" width="auto">currency</th>
                                      <th field="order_status_id" width="auto">status</th>
                                     <th field="date_added" width="auto">date added</th>
                                     <th field="date_modified" width="auto">date modified</th>
                        </tr>
                </thead>
        </table>

</body>
</html>
<?php     
}        