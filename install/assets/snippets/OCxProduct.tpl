/**
     * OCxProduct 
     *
	 * Display Open Cart 2 products in MODX Evolution
     *
     * @author Nicola Lambathakis
     * @version 1.0
     * @author	Nicola Lambathakis
     * @internal	@modx_category OCx
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 */

	/**
    Sample call
[[OCxProduct? &id=`60` &opencartTpl=`opencartTpl`]]
*/

function substrwords1($text, $maxchar, $end='...') {
    if (strlen($text) > $maxchar || $text == '') {
        $words = preg_split('/\s/', $text);      
        $output = '';
        $i      = 0;
        while (1) {
            $length = strlen($output)+strlen($words[$i]);
            if ($length > $maxchar) {
                break;
            } 
            else {
                $output .= " " . $words[$i];
                ++$i;
            }
        }
        $output .= $end;
    } 
    else {
        $output = $text;
    }
    return $output;
}
$trim = (isset($trim)) ? $trim : '200';
$db_server = new mysqli($oc_db_hostname,$oc_db_username,$oc_db_password,$oc_db_database); 
if (mysqli_connect_errno()) { 
    printf("Can't connect to MySQL Server. Errorcode: %s\n", mysqli_connect_error()); 
    exit; 
} 
   

$result0 = mysqli_query($db_server, "SELECT * FROM oc_product WHERE product_id IN ($id)")
or die(mysqli_error()); if (!$result0) die ("Database access failed: " . mysqli_error());

if ( mysqli_num_rows( $result0 ) < 1 )
{
     echo" Product id $id not found";
}
else
{
while($row0 = mysqli_fetch_array( $result0 )) {
    $id = $row0['product_id'];
	$image = $row0['image'];
	$isbn = $row0['isbn'];
	
 // oc product name and description	
    $result2 = mysqli_query($db_server, "SELECT DISTINCT * FROM oc_product_description WHERE product_id IN ($id) GROUP BY product_id");
    while($row2 = mysqli_fetch_array( $result2 )) {
        $name = $row2['name'];
        $htmldescription = $row2['description'];
        $description = html_entity_decode($htmldescription);
		$flat_description = strip_tags($description);
		$short_description = substrwords1($flat_description,$trim);
 // oc product price
        $result3 = mysqli_query($db_server, "SELECT DISTINCT * FROM oc_product WHERE product_id IN ($id) GROUP BY product_id");
        while($row3 = mysqli_fetch_array( $result3 )) {
            $price = sprintf('%0.2f', $row3['price']);
        }
		
 // oc product special price
        $result4 = mysqli_query($db_server, "SELECT DISTINCT * FROM oc_product_special WHERE product_id IN ($id) GROUP BY product_id");
        while($row = mysqli_fetch_array( $result4)) {
            $spprice = sprintf('%0.2f', $row4['price']);
        }
		
		
 // oc product url alias for friendly urls link		
    $result5 = mysqli_query($db_server, "SELECT DISTINCT * FROM oc_url_alias WHERE query='product_id=$id'");
    while($row5 = mysqli_fetch_array( $result5 )) {
    $keyword = $row5['keyword'];
		}
		
// define the placeholders and set their values
$opencartTpl = (isset($opencartTpl)) ? $opencartTpl : 'opencartTpl';
$product_url = "$oc_shop_url/index.php?route=product/product&product_id=$id";
$product_alias_url = "$oc_shop_url/$keyword";
$buy_from_amazon = "http://www.$oc_amazon/dp/$isbn?tag=$oc_affiliate_amazon_tag";

		// parse the chunk and replace the placeholder values.
// note that the values need to be in an array with the format placeholderName => placeholderValue
$values = array('ocimage' => $image, 'ocid' => $id, 'ocname' => $name, 'ocdescription' => $description, 'ocshort_description' => $short_description,'ocprice' => $price, 'ocspprice' => $spprice, 'ocalias' => $keyword, 'ocshop_url' => $oc_shop_url, 'ocproduct_url' => $product_url, 'ocproduct_alias_url' => $product_alias_url, 'buy_from_amazon' => $buy_from_amazon);

//   
$output =  $output . $modx->parseChunk($opencartTpl, $values, '[+', '+]');
	}
	}
}//end while 'Get product IDs in right category'
mysqli_close($db_server);


return $output;
?>