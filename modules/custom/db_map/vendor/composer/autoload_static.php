<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInita0c6969eca3e4dbaf7521e57e1945662
{
    public static $prefixLengthsPsr4 = array (
        'B' => 
        array (
            'Box\\Spout\\' => 10,
        ),
    );

    public static $prefixDirsPsr4 = array (
        'Box\\Spout\\' => 
        array (
            0 => __DIR__ . '/..' . '/box/spout/src/Spout',
        ),
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->prefixLengthsPsr4 = ComposerStaticInita0c6969eca3e4dbaf7521e57e1945662::$prefixLengthsPsr4;
            $loader->prefixDirsPsr4 = ComposerStaticInita0c6969eca3e4dbaf7521e57e1945662::$prefixDirsPsr4;

        }, null, ClassLoader::class);
    }
}