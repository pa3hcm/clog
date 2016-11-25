<?php
/*
Plugin Name: WP-CLog
Plugin URI: http://github.com/pa3hcm/clog
Description: Simple plugin to publish your CLog (version 0.9b or later) hamradio logbook in WordPress.
Version: 0.01
Author: Ernest Neijenhuis PA3HCM
Author URI: http://www.pa3hcm.nl/
*/

add_shortcode('wpclog-list', 'wpclog_gen');
register_activation_hook(__FILE__, 'wpclog_add_defaults');
register_uninstall_hook(__FILE__, 'wpclog_delete_plugin_options');
add_action('admin_init', 'wpclog_init' );
add_action('admin_menu', 'wpclog_add_options_page');
add_filter( 'plugin_action_links', 'wpclog_plugin_action_links', 10, 2 );
add_filter('widget_text', 'do_shortcode'); // make WP-CLog shortcode work in text widgets

/* Delete options table entries ONLY when plugin deactivated AND deleted. */
function wpclog_delete_plugin_options() {
	delete_option('wpclog_options');
}

/* Define default option settings. */
function wpclog_add_defaults() {

	$tmp = get_option('wpclog_options');
	if( ( (isset($tmp['chk_default_options_db']) && $tmp['chk_default_options_db']=='1')) || (!is_array($tmp)) ) {
		delete_option('wpclog_options');
		$arr = array(	"db_host"	=> "localhost",
				"db_port"	=> "3306",
				"db_name"	=> "clog",
				"db_user"	=> "cloguser",
				"db_pass"	=> "clogpass",
				"mycall"	=> "NOCALL"
		);
		update_option( 'wpclog_options', $arr );
	}

	// Make sure that something displays on the front end (i.e. the post, page, CPT check boxes are not all off)
	$tmp1 = get_option('wpclog_options');
	if( isset($tmp1) && is_array($tmp1) ) {
		if( !( isset($tmp1['db_host']) ) ) {
			$tmp1['db_host'] = "localhost";
		}
		if( !( isset($tmp1['db_port']) ) ) {
			$tmp1['db_port'] = "3306";
		}
		if( !( isset($tmp1['db_name']) ) ) {
			$tmp1['db_name'] = "clog";
		}
		if( !( isset($tmp1['db_user']) ) ) {
			$tmp1['db_user'] = "cloguser";
		}
		if( !( isset($tmp1['db_pass']) ) ) {
			$tmp1['db_pass'] = "clogpass";
		}
		if( !( isset($tmp1['mycall']) ) ) {
			$tmp1['mycall'] = "NOCALL";
		}

		update_option( 'wpclog_options', $tmp1 );
	}
}

/* Init plugin options to white list our options. */
function wpclog_init(){

	register_setting( 'wpclog_plugin_options', 'wpclog_options', 'wpclog_validate_options' );
}

/* Add menu page. */
function wpclog_add_options_page() {
	add_options_page('WP-CLog Options Page', 'WP-CLog', 'manage_options', __FILE__, 'wpclog_render_form');
}

/* Draw the menu page itself. */
function wpclog_render_form() {
	?>
	<div class="wrap">
		<h2>WP-CLog Options</h2>

		<div style="background:#eee;border: 1px dashed #ccc;font-size: 13px;margin: 20px 0 10px 0;padding: 5px 0 5px 8px;">To display the 25 most recent QSO's of the CLog database on a post, page, or sidebar (via a Text widget), enter the following <a href="http://codex.wordpress.org/Shortcode_API" target="_blank">shortcode</a>: <b>[wpclog-list]</b>. To modify the number of listed QSO's add the <i>limit</i> parameter, e.g. <b>[wpclog-list limit=100]</b>.</div>
		<form method="post" action="options.php">
			<?php settings_fields('wpclog_plugin_options'); ?>
			<?php $options = get_option('wpclog_options'); ?>
			<table class="form-table">
				<tr>
					<th scope="row">My callsign</th>
					<td>
						<input type="text" size="30" name="wpclog_options[mycall]" value="<?php echo $options['mycall']; ?>" /><p class="description">Enter your callsign, must be the same as the <i>mycall</i> setting in your <i>.clogrc</i> file.</p>
					</td>
				</tr>
				<tr>
					<th scope="row">Database host</th>
					<td>
						<input type="text" size="30" name="wpclog_options[db_host]" value="<?php echo $options['db_host']; ?>" /><p class="description">Enter the hostname or IP-address of the MySQL server that hosts the CLog database.</p>
					</td>
				</tr>
				<tr>
					<th scope="row">Database port</th>
					<td>
						<input type="text" size="30" name="wpclog_options[db_port]" value="<?php echo $options['db_port']; ?>" /><p class="description">Enter the MySQL TCP port number (normally 3306 unless you changed it).</p>
					</td>
				</tr>
				<tr>
					<th scope="row">Database name</th>
					<td>
						<input type="text" size="30" name="wpclog_options[db_name]" value="<?php echo $options['db_name']; ?>" /><p class="description">Enter the name of the CLog database.</p>
					</td>
				</tr>
				<tr>
					<th scope="row">Database username</th>
					<td>
						<input type="text" size="30" name="wpclog_options[db_user]" value="<?php echo $options['db_user']; ?>" /><p class="description">Enter the username to login to the CLog database.</p>
					</td>
				</tr>
				<tr>
					<th scope="row">Database password</th>
					<td>
						<input type="text" size="30" name="wpclog_options[db_pass]" value="<?php echo $options['db_pass']; ?>" /><p class="description">Enter the username's password.</p>
					</td>
				</tr>
			</table> 
			<p>Note: you may review the settings in your <i>.clogrc</i> file to find the correct values for the fields above.</p>
			<p class="submit">
			<input type="submit" class="button-primary" value="<?php _e('Save Changes') ?>" />
			</p>
		</form>
	</div>
	<?php	
}

/* Shortcode function. */
function wpclog_gen($atts) {
	extract( shortcode_atts( array(
		'limit' => '25',
	), $atts, 'wpclog-list' ) );

	ob_start(); // start output caching (so that existing content in the [wpclog-list] post doesn't get shoved to the bottom of the post
	$opt = get_option('wpclog_options');

	$wpclog_db = new mysqli($opt['db_host'], $opt['db_user'], $opt['db_pass'], $opt['db_name'], $opt['db_port']);
	if ($wpclog_db->connect_errno) {
		echo "<p><b>Sorry</b>, the live logbook is not available at this moment...</p>";
	}

	$wpclog_db_stmt = $wpclog_db->prepare("SELECT id, mycall, callsign, qso_date, TIME_FORMAT(qso_time, '%H:%i') AS qso_time, FORMAT(freq, 3) AS freq, mode, qsl_tx, qsl_rx FROM qsos WHERE mycall=? ORDER BY qso_date DESC, qso_time DESC, id LIMIT ? ;");

	$wpclog_db_stmt->bind_param('si', $opt['mycall'], $limit);
	$wpclog_db_stmt->execute();
	$wpclog_db_stmt->bind_result($wpclog_res_id, $wpclog_res_mycall, $wpclog_res_callsign, $wpclog_res_qso_date, $wpclog_res_qso_time, $wpclog_res_freq, $wpclog_res_mode, $wpclog_res_qsl_tx, $wpclog_res_qsl_rx);
?>

<div class="wpclog_wrapper">

<table>
	<tr>
		<th>Callsign</th>
		<th>Date<br/>(yyyy-mm-dd)</th>
		<th>Time UTC</th>
		<th>Frequency<br/>[MHz]</th>
		<th>Mode</th>
		<th>QSL Sent</th>
		<th>QSL Received</th>
	</tr>

<?php
	while ($wpclog_db_stmt->fetch()) {
		if ($wpclog_res_qsl_tx == 'Y') {
			$wpclog_res_qsl_tx = 'yes';
		} else {
			$wpclog_res_qsl_tx = '-';
		}
		if ($wpclog_res_qsl_rx == 'Y') {
			$wpclog_res_qsl_rx = 'yes, many thanks!';
		} else {
			$wpclog_res_qsl_rx = '-';
		}
		echo "	<tr>
				<td>" . $wpclog_res_callsign . "</td>
				<td>" . $wpclog_res_qso_date . "</td>
				<td>" . $wpclog_res_qso_time . "</td>
				<td>" . $wpclog_res_freq . "</td>
				<td>" . $wpclog_res_mode . "</td>
				<td>" . $wpclog_res_qsl_tx . "</td>
				<td>" . $wpclog_res_qsl_rx . "</td>
			</tr>\n";
	}
?>

</table>

</div>
<?php

$wpclog_db_stmt->close();
$wpclog_db->close();

$output = ob_get_contents();;
ob_end_clean();

return $output;

}

// Display a Settings link on the main Plugins page
function wpclog_plugin_action_links( $links, $file ) {

	if ( $file == plugin_basename( __FILE__ ) ) {
		$posk_links = '<a href="'.get_admin_url().'options-general.php?page=wp-clog/wp-clog.php">'.__('Settings').'</a>';
		// make the 'Settings' link appear first
		array_unshift( $links, $posk_links );
	}

	return $links;
}

/* Sanitize and validate input. Accepts an array, return a sanitized array. */
function wpclog_validate_options($input) {
	// Strip html from textboxes
	// e.g. $input['textbox'] =  wp_filter_nohtml_kses($input['textbox']);

	$input['txt_page_ids'] = sanitize_text_field( $input['txt_page_ids'] );

	return $input;
}
