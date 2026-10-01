<?php

function saitheme_enqueue_styles()
{

    wp_enqueue_style(
        'saitheme-style',
        get_stylesheet_uri(),
        array(),
        '2.0'
    );
}

add_action('wp_enqueue_scripts', 'saitheme_enqueue_styles');
