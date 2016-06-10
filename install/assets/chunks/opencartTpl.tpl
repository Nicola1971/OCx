/**
 * opencartTpl
 *
 * OCx Open Cart product template
 * @author      Author: Nicola Lambathakis http://www.tattoocms.it/
 * @version 1.7.1
 * @category	chunk
 * @internal @modx_category OCx
 */
<div class="row blog-post margin-bottom-10">
<div class="col-md-5">
<img class="img-responsive img-rounded img-thumbnail" src="[+ocimage+]" alt="[+ocname+]">
</div>
<div class="col-md-7">
	<a href="[+ocproduct_alias_url+]" title="[+ocname+]"><h3>[+ocname+]</h3></a>
[+ocshort_description+]
	<h4 class="text-success">[+ocprice+] €</h4>
<!--<a class="btn btn-default" href="[+ocproduct_url+]"><i class="fa fa-share"></i> Details</a>-->
<a class="btn btn-default" href="[+ocproduct_alias_url+]"><i class="fa fa-share"></i> Details</a>
	<a target="_blank" rel="nofollow" class="btn btn-danger" href="[+ocshop_url+]/index.php?route=checkout/cart/addlink&product_id=[+ocid+]&quantity=1"><i class="fa fa-shopping-cart" aria-hidden="true"></i> Add to Cart</a>
<a target="_blank" rel="nofollow" class="btn btn-warning" href="[+buy_from_amazon+]"><i class="fa fa-amazon" aria-hidden="true"></i> buy from Amazon</a>

</div>
</div>