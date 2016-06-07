/**
     * OCxCategory
     *
	 * Display Open Cart Categories in MODX Evolution
     *
     * @author      Author: Nicola Lambathakis http://www.tattoocms.it/
     * @version 1.6.3
     * @internal	@modx_category OCx
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 */
/**
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

if(!function_exists('substrwords')) {	
function substrwords($text, $maxchar, $end='...') {
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
}

/**********************/
	/***********/
	/**
Funcion fetch images 
	credits: 
http://www.intechgrity.com/automatically-copy-images-png-jpeg-gif-from-remote-server-http-to-your-local-server-using-php/#
*/
if(!function_exists('itg_fetch_image')) {		
function itg_fetch_image($img_url, $store_dir, $store_dir_type, $overwrite, $pref, $debug) {
    //first get the base name of the image
    $i_name = explode('.', basename($img_url));
    $i_name = $i_name[0];
	
		    //second get the dir name of the image
    $i_path = explode('.', dirname($img_url));
    $i_path = $i_path[0];
	$subfolders = explode('/', $i_path);
	
	$urlparts = parse_url($img_url);
$remotepath = $urlparts['path'].'?'.$urlparts['query'];
	
	
     //now try to guess the image type from the given url
    //it should end with a valid extension...
    //good for security too
    if(preg_match('/https?:\/\/.*\.png$/i', $img_url)) {
        $img_type = 'png';
    }
    else if(preg_match('/https?:\/\/.*\.(jpg|jpeg)$/i', $img_url)) {
        $img_type = 'jpg';
    }
    else if(preg_match('/https?:\/\/.*\.gif$/i', $img_url)) {
        $img_type = 'gif';
    }
    else {
        if(true == $debug)
            echo ''.$oclocal_image,' Invalid image URL';
        return ''; //possible error on the image URL
    }
 
    $dir_name = (($store_dir_type == 'relative')? './' : '') . rtrim($store_dir, '/') . '/';
 
     //create the directory if not present
    if(!file_exists($dir_name))
        mkdir($dir_name, 0777, true);
 
    //calculate the destination image path
    $i_dest = $dir_name . $i_name . (($pref === false)? '' : '_' . $pref) . '.' . $img_type;
	
    //lets see if the path exists already
    if(file_exists($i_dest)) {
        $pref = (int) $pref;
 
        //modify the file name, do not overwrite
        if(rename == $overwrite)
				
			  return itg_fetch_image($img_url, $store_dir, $store_dir_type, $overwrite, ++$pref, $debug);
		
		 else if(false == $overwrite) {
         echo '';
    }
        //delete & overwrite
        else
            unlink ($i_dest);
    }
 
    //first check if the image is fetchable
    $img_info = @getimagesize($img_url);
 
    //is it a valid image?
    if(false == $img_info || !isset($img_info[2]) || !($img_info[2] == IMAGETYPE_JPEG || $img_info[2] == IMAGETYPE_PNG || $img_info[2] == IMAGETYPE_JPEG2000 || $img_info[2] == IMAGETYPE_GIF)) {
        if(true == $debug)
            echo 'The image doesn\'t seem to exist in the remote server';
        return ''; //return empty string
    }
 
    //now try to create the image
    if($img_type == 'jpg') {
        $m_img = @imagecreatefromjpeg($img_url);
    } else if($img_type == 'png') {
        $m_img = @imagecreatefrompng($img_url);
        @imagealphablending($m_img, false);
        @imagesavealpha($m_img, true);
    } else if($img_type == 'gif') {
        $m_img = @imagecreatefromgif($img_url);
    } else {
        $m_img = FALSE;
    }
 
    //was the attempt successful?
    if(FALSE === $m_img) {
        if(true == $debug)
            echo 'Can not create image from the URL';
        return '';
    }
 
    //now attempt to save the file on local server
    if($img_type == 'jpg') {
        if(imagejpeg($m_img, $i_dest, 100))
            return $i_dest;
        else
            return '';
    } else if($img_type == 'png') {
        if(imagepng($m_img, $i_dest, 0))
            return $i_dest;
        else
            return '';
    } else if($img_type == 'gif') {
        if(imagegif($m_img, $i_dest))
            return $i_dest;
        else
            return '';
    }
 
    return '';
}
	}
//end fetch images
/*****************/


$db_server = new mysqli($oc_db_hostname,$oc_db_username,$oc_db_password,$oc_db_database);  
if (mysqli_connect_errno()) { 
    printf("Can't connect to MySQL Server. Errorcode: %s\n", mysqli_connect_error()); 
    exit; 
}

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
	  
	  
 // oc product id and image	FROM oc_product 
$result1 = mysqli_query($db_server, "SELECT DISTINCT * FROM oc_product WHERE product_id='$id' GROUP BY product_id ORDER BY $orderby $orderdir LIMIT $limit");
while($row1 = mysqli_fetch_array( $result1 )) {
	$image = $row1['image'];
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
		
 // oc product price FROM oc_product  
        $result3 = mysqli_query($db_server, "SELECT DISTINCT * FROM oc_product WHERE product_id='$id' GROUP BY product_id ORDER BY $orderby $orderdir LIMIT $limit");
        while($row3 = mysqli_fetch_array( $result3 )) {
            $price = sprintf('%0.2f', $row3['price']);
        }
		
 // oc product special price FROM oc_product_special 
        $result4 = mysqli_query($db_server, "SELECT DISTINCT * FROM oc_product_special WHERE product_id='$id' GROUP BY product_id ORDER BY $orderby $orderdir LIMIT $limit");
        while($row = mysqli_fetch_array( $result4)) {
            $spprice = sprintf('%0.2f', $row4['price']);
        }
		
 // oc product url alias for friendly urls link	FROM oc_url_alias  	
    $result5 = mysqli_query($db_server, "SELECT DISTINCT * FROM oc_url_alias WHERE query='product_id=$id' LIMIT $limit");
    while($row5 = mysqli_fetch_array( $result5 )) {
    $keyword = $row5['keyword'];
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
		$d_description = mb_convert_encoding($short_description, 'HTML-ENTITIES', $charset);
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
}//end while 'Get product IDs in right category'
mysqli_close($db_server);


return $output;
?>