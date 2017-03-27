<?php

if (preg_match('/\.dev|\.docker/', $_SERVER['HTTP_HOST'])) {
    $_SERVER['HTTP_HOST'] = isset($_SERVER['HTTP_X_FORWARDED_HOST']) ? $_SERVER['HTTP_X_FORWARDED_HOST'] : $_SERVER['HTTP_HOST'];
}

// Other stuff