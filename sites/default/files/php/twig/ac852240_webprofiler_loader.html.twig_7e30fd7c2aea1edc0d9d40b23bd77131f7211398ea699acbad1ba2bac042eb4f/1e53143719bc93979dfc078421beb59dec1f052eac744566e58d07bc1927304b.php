<?php

/* modules/devel/webprofiler/templates/Profiler/webprofiler_loader.html.twig */
class __TwigTemplate_0e218d02db352ea87eb8b5f21a456c6b96c075c62c38f95245b395b8220c491c extends Twig_Template
{
    public function __construct(Twig_Environment $env)
    {
        parent::__construct($env);

        $this->parent = false;

        $this->blocks = array(
        );
    }

    protected function doDisplay(array $context, array $blocks = array())
    {
        $__internal_54dd3a7a21d776adf86a52e143df337303b4f1e73260a582291c61efd1ee83e3 = $this->env->getExtension("native_profiler");
        $__internal_54dd3a7a21d776adf86a52e143df337303b4f1e73260a582291c61efd1ee83e3->enter($__internal_54dd3a7a21d776adf86a52e143df337303b4f1e73260a582291c61efd1ee83e3_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "modules/devel/webprofiler/templates/Profiler/webprofiler_loader.html.twig"));

        $tags = array();
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array(),
                array(),
                array()
            );
        } catch (Twig_Sandbox_SecurityError $e) {
            $e->setTemplateFile($this->getTemplateName());

            if ($e instanceof Twig_Sandbox_SecurityNotAllowedTagError && isset($tags[$e->getTagName()])) {
                $e->setTemplateLine($tags[$e->getTagName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFilterError && isset($filters[$e->getFilterName()])) {
                $e->setTemplateLine($filters[$e->getFilterName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFunctionError && isset($functions[$e->getFunctionName()])) {
                $e->setTemplateLine($functions[$e->getFunctionName()]);
            }

            throw $e;
        }

        // line 1
        echo "<div id=\"webprofiler";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["token"]) ? $context["token"] : null), "html", null, true));
        echo "\" class=\"sf-toolbar\" style=\"display: none\"></div>

<script>
    Webprofiler = (function () {
        \"use strict\";

        var key = 'webprofiler/profiler/',

                getPreference = function (name) {
                    if (!window.localStorage) {
                        return null;
                    }

                    return localStorage.getItem(key + name);
                },

                setPreference = function (name, value) {
                    if (!window.localStorage) {
                        return null;
                    }

                    localStorage.setItem(key + name, value);
                    return true;
                },

                load = function () {
                    ajax('";
        // line 27
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["profiler_url"]) ? $context["profiler_url"] : null), "html", null, true));
        echo "', function (result) {
                        var toolbar = document.getElementById('webprofiler";
        // line 28
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["token"]) ? $context["token"] : null), "html", null, true));
        echo "');
                        toolbar.innerHTML = result;
                        toolbar.style.display = 'block';

                        if (getPreference('toolbar/displayState') == 'none') {
                            document.getElementById('sfToolbarMainContent-";
        // line 33
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["token"]) ? $context["token"] : null), "html", null, true));
        echo "').style.display = 'none';
                            document.getElementById('sfToolbarClearer-";
        // line 34
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["token"]) ? $context["token"] : null), "html", null, true));
        echo "').style.display = 'none';
                            document.getElementById('sfMiniToolbar-";
        // line 35
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["token"]) ? $context["token"] : null), "html", null, true));
        echo "').style.display = 'block';
                        } else {
                            document.getElementById('sfToolbarMainContent-";
        // line 37
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["token"]) ? $context["token"] : null), "html", null, true));
        echo "').style.display = 'block';
                            document.getElementById('sfToolbarClearer-";
        // line 38
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["token"]) ? $context["token"] : null), "html", null, true));
        echo "').style.display = 'block';
                            document.getElementById('sfMiniToolbar-";
        // line 39
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["token"]) ? $context["token"] : null), "html", null, true));
        echo "').style.display = 'none';
                        }

                        var arr = toolbar.getElementsByTagName('script');
                        for (var n = 0; n < arr.length; n++) {
                            eval(arr[n].innerHTML);
                        }
                    });
                },

                ajax = function (url, callback, data) {
                    try {
                        var x = new (XMLHttpRequest || ActiveXObject)('MSXML2.XMLHTTP.3.0');
                        x.open(data ? 'POST' : 'GET', url, 1);
                        x.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
                        x.setRequestHeader('Content-type', 'application/json');
                        x.onreadystatechange = function () {
                            x.readyState > 3 && x.status === 200 && callback && callback(x.responseText, x);
                        };
                        x.send(data);
                    } catch (e) {
                        window.console && console.log(e);
                    }
                };

        return {
            getPreference: getPreference,
            setPreference: setPreference,
            load: load,
            ajax: ajax
        }
    })();

    Webprofiler.load();
</script>
";
        
        $__internal_54dd3a7a21d776adf86a52e143df337303b4f1e73260a582291c61efd1ee83e3->leave($__internal_54dd3a7a21d776adf86a52e143df337303b4f1e73260a582291c61efd1ee83e3_prof);

    }

    public function getTemplateName()
    {
        return "modules/devel/webprofiler/templates/Profiler/webprofiler_loader.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  109 => 39,  105 => 38,  101 => 37,  96 => 35,  92 => 34,  88 => 33,  80 => 28,  76 => 27,  46 => 1,);
    }
}
/* <div id="webprofiler{{ token }}" class="sf-toolbar" style="display: none"></div>*/
/* */
/* <script>*/
/*     Webprofiler = (function () {*/
/*         "use strict";*/
/* */
/*         var key = 'webprofiler/profiler/',*/
/* */
/*                 getPreference = function (name) {*/
/*                     if (!window.localStorage) {*/
/*                         return null;*/
/*                     }*/
/* */
/*                     return localStorage.getItem(key + name);*/
/*                 },*/
/* */
/*                 setPreference = function (name, value) {*/
/*                     if (!window.localStorage) {*/
/*                         return null;*/
/*                     }*/
/* */
/*                     localStorage.setItem(key + name, value);*/
/*                     return true;*/
/*                 },*/
/* */
/*                 load = function () {*/
/*                     ajax('{{ profiler_url }}', function (result) {*/
/*                         var toolbar = document.getElementById('webprofiler{{ token }}');*/
/*                         toolbar.innerHTML = result;*/
/*                         toolbar.style.display = 'block';*/
/* */
/*                         if (getPreference('toolbar/displayState') == 'none') {*/
/*                             document.getElementById('sfToolbarMainContent-{{ token }}').style.display = 'none';*/
/*                             document.getElementById('sfToolbarClearer-{{ token }}').style.display = 'none';*/
/*                             document.getElementById('sfMiniToolbar-{{ token }}').style.display = 'block';*/
/*                         } else {*/
/*                             document.getElementById('sfToolbarMainContent-{{ token }}').style.display = 'block';*/
/*                             document.getElementById('sfToolbarClearer-{{ token }}').style.display = 'block';*/
/*                             document.getElementById('sfMiniToolbar-{{ token }}').style.display = 'none';*/
/*                         }*/
/* */
/*                         var arr = toolbar.getElementsByTagName('script');*/
/*                         for (var n = 0; n < arr.length; n++) {*/
/*                             eval(arr[n].innerHTML);*/
/*                         }*/
/*                     });*/
/*                 },*/
/* */
/*                 ajax = function (url, callback, data) {*/
/*                     try {*/
/*                         var x = new (XMLHttpRequest || ActiveXObject)('MSXML2.XMLHTTP.3.0');*/
/*                         x.open(data ? 'POST' : 'GET', url, 1);*/
/*                         x.setRequestHeader('X-Requested-With', 'XMLHttpRequest');*/
/*                         x.setRequestHeader('Content-type', 'application/json');*/
/*                         x.onreadystatechange = function () {*/
/*                             x.readyState > 3 && x.status === 200 && callback && callback(x.responseText, x);*/
/*                         };*/
/*                         x.send(data);*/
/*                     } catch (e) {*/
/*                         window.console && console.log(e);*/
/*                     }*/
/*                 };*/
/* */
/*         return {*/
/*             getPreference: getPreference,*/
/*             setPreference: setPreference,*/
/*             load: load,*/
/*             ajax: ajax*/
/*         }*/
/*     })();*/
/* */
/*     Webprofiler.load();*/
/* </script>*/
/* */
