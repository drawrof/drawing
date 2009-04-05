<?php

// Clean the id, which is essentially the filename
if (!empty($_POST['id'])) {
	$id = preg_replace('/[^a-z0-9]/','',strtolower($_POST['id']));
	$directory = rtrim(realpath('drawings'),'/').'/';
	$filename = $directory.$id.'.txt';
}

// Refresh the canvas...
if (empty($_POST['queue'])) {
	if (file_exists($filename)) {
		$drawing = gzuncompress(file_get_contents($filename));
		echo $drawing;
	}
	
// Clear the canvas
} else if ($_POST['queue'] == 'clear') {
	if (file_exists($filename)) {
		unlink($filename);
	}
	
// Append the contents
} else {
	if (is_writable($directory)) {
		if (file_exists($filename)) {
			$data = gzuncompress(file_get_contents($filename));
		} else {
			$data = '';
		}
		file_put_contents($filename,gzcompress($data.$_POST['queue'],9));
	}
}