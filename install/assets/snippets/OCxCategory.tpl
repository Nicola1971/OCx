/**
     * OCxCategory
     *
	 * Display Open Cart Categories in MODX Evolution
     *
     * @author      Author: Nicola Lambathakis http://www.tattoocms.it/
     * @version 1.6.5
     * @internal	@modx_category OCx
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 */
 
if(!defined('MODX_BASE_PATH')){die('What are you doing? Get out of here!');}
/**
    Sample call
[[OCxCategory? &cat=`3` &opencartTpl=`opencartTpl` &fetchimages=`0` &limit=`50` &orderdir=`DESC` &orderby=`product_id`]]
*/

	/*define snippet params*/
$opencartTpl = (isset($opencartTpl)) ? $opencartTpl : 'opencartTpl';
$limit = (isset($limit)) ? $limit : '50';
$trim = (isset($trim)) ? $trim : '200';
$orderdir = (isset($orderdir)) ? $orderdir : 'DESC';
$orderby = (isset($orderby)) ? $orderby : 'product_id';
$fetchimages = (isset($fetchimages)) ? $fetchimages : '0'; 
$store_dir = (isset($store_dir)) ? $store_dir : 'assets/images/ocx';
$store_dir_type = (isset($store_dir_type)) ? $store_dir_type : 'relative';
$overwrite = (isset($overwrite)) ? $overwrite : 'false';
$pref = (isset($pref)) ? $pref : 'false';
$debug = (isset($debug)) ? $debug : 'true';
$convert = (isset($convert)) ? $convert : '0';
$charset = (isset($charset)) ? $charset : 'ISO-8859-1';
$trim = (isset($trim)) ? $trim : '200';

include_once(MODX_BASE_PATH . 'assets/snippets/ocx/ocx.functions.php');  

$db_server = new mysqli($oc_db_hostname,$oc_db_username,$oc_db_password,$oc_db_database);  
if (mysqli_connect_errno()) { 
    printf("Can't connect to MySQL Server. Errorcode: %s\n", mysqli_connect_error()); 
    exit; 
}
 // oc product categoory id FROM oc_product_to_category 
$result0 = mysqli_query($db_server, "SELECT DISTINCT * FROM oc_product_to_category WHERE category_id IN ($cat) GROUP BY product_id ORDER BY $orderby $orderdir LIMIT $limit")
or die(mysqli_error($db_server)); if (!$result0) die ("Database access failed: " . mysqli_error());

if ( mysqli_num_rows( $result0 ) < 1 )
{
     echo" Category id $cat not found";
}
else
{
	
while($row0 = mysqli_fetch_array( $result0 )) {
	$id = $row0['product_id'];
	  
	  
 // oc product id, price and image	FROM oc_product 
$result1 = mysqli_query($db_server, "SELECT DISTINCT * FROM oc_product WHERE product_id='$id' GROUP BY product_id ORDER BY $orderby $orderdir LIMIT $limit");
while($row1 = mysqli_fetch_array( $result1 )) {
	$image = $row1['image'];
	$price = sprintf('%0.2f', $row1['price']);
	$isbn = $row1['isbn'];
	$remote_image = "$oc_shop_url/$oc_image_folder$image";
	
	if($fetchimages == '0') {
	$oc_image = $remote_image;
	}
	else 
	if($fetchimages == '1') {
	$oc_image = itg_fetch_image($remote_image, $store_dir, $store_dir_type, $overwrite, $pref, $debug);
}
  }

// oc product name and description	FROM oc_product_description 
    $result2 = mysqli_query($db_server, "SELECT DISTINCT * FROM oc_product_description WHERE product_id='$id' GROUP BY product_id ORDER BY $orderby $orderdir LIMIT $limit");
    while($row2 = mysqli_fetch_array( $result2 )) {
        $name = $row2['name'];
        $htmldescription = $row2['description'];
        $description = html_entity_decode($htmldescription);
		$flat_description = strip_tags($description);
		$short_description = substrwords($flat_description,$trim);

// oc product special price FROM oc_product_special
        $result3 = mysqli_query($db_server, "SELECT DISTINCT * FROM oc_product_special WHERE product_id='$id' GROUP BY product_id ORDER BY $orderby $orderdir LIMIT $limit");
        while($row = mysqli_fetch_array( $result3)) {
            $spprice = sprintf('%0.2f', $row3['price']);
        }
// oc product url alias for friendly urls link	FROM oc_url_alias  	
    $result4 = mysqli_query($db_server, "SELECT DISTINCT * FROM oc_url_alias WHERE query='product_id=$id' LIMIT $limit");
    while($row4 = mysqli_fetch_array( $result4 )) {
    $keyword = $row4['keyword'];
		}
		
// define the placeholders and set their values
$opencartTpl = (isset($opencartTpl)) ? $opencartTpl : 'opencartTpl';
$product_url = "$oc_shop_url/index.php?route=product/product&product_id=$id";
$product_alias_url = "$oc_shop_url/$keyword";
$buy_from_amazon = "http://www.$oc_amazon/dp/$isbn?tag=$oc_affiliate_amazon_tag";

// convert charset				
		if($convert == '1')
		{
		$d_name = mb_convert_encoding($name, 'HTML-ENTITIES', $charset);
		$d_short_description = mb_convert_encoding($short_description, 'HTML-ENTITIES', $charset);
		$d_description = mb_convert_encoding($description, 'HTML-ENTITIES', $charset);
		$d_product_alias_url = mb_convert_encoding($product_alias_url, 'HTML-ENTITIES', $charset);
		}	
		else {
		$d_name = $name;
		$d_short_description = $short_description;
		$d_description = $description;
		$d_product_alias_url = $product_alias_url;
		}		

// parse the chunk and replace the placeholder values.
// note that the values need to be in an array with the format placeholderName => placeholderValue
$values = array('ocimage' => $oc_image, 'ocid' => $id, 'ocname' => $d_name, 'ocdescription' => $d_description, 'ocshort_description' => $d_short_description,'ocprice' => $price, 'ocspprice' => $spprice, 'ocalias' => $keyword, 'ocshop_url' => $oc_shop_url, 'ocproduct_url' => $product_url, 'ocproduct_alias_url' => $d_product_alias_url, 'buy_from_amazon' => $buy_from_amazon);

//   
$output =  $output . $modx->parseChunk($opencartTpl, $values, '[+', '+]');
	}
	}
}//end 
mysqli_close($db_server);


return $output;
?>