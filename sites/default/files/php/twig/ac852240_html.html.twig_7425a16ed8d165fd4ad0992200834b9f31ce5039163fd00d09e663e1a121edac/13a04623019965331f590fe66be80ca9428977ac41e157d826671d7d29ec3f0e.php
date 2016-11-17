<?php

/* themes/bootstrap/templates/system/html.html.twig */
class __TwigTemplate_2c5f9cfb38e66e3d5cd16d40e3673a4ff734af612f64a630c3ac480e9560b0f4 extends Twig_Template
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
        $__internal_c079a47588bbf060137179b79efb45a91268d786aec96798d7245c84016fed66 = $this->env->getExtension("native_profiler");
        $__internal_c079a47588bbf060137179b79efb45a91268d786aec96798d7245c84016fed66->enter($__internal_c079a47588bbf060137179b79efb45a91268d786aec96798d7245c84016fed66_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "themes/bootstrap/templates/system/html.html.twig"));

        $tags = array("set" => 48);
        $filters = array("clean_class" => 50, "raw" => 60, "safe_join" => 61, "t" => 67);
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('set'),
                array('clean_class', 'raw', 'safe_join', 't'),
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

        // line 48
        $context["body_classes"] = array(0 => ((        // line 49
(isset($context["logged_in"]) ? $context["logged_in"] : null)) ? ("user-logged-in") : ("")), 1 => (( !        // line 50
(isset($context["root_path"]) ? $context["root_path"] : null)) ? ("path-frontpage") : (("path-" . \Drupal\Component\Utility\Html::getClass((isset($context["root_path"]) ? $context["root_path"] : null))))), 2 => ((        // line 51
(isset($context["node_type"]) ? $context["node_type"] : null)) ? (("page-node-type-" . \Drupal\Component\Utility\Html::getClass((isset($context["node_type"]) ? $context["node_type"] : null)))) : ("")), 3 => ((        // line 52
(isset($context["db_offline"]) ? $context["db_offline"] : null)) ? ("db-offline") : ("")), 4 => (($this->getAttribute($this->getAttribute(        // line 53
(isset($context["theme"]) ? $context["theme"] : null), "settings", array()), "navbar_position", array())) ? (("navbar-is-" . $this->getAttribute($this->getAttribute((isset($context["theme"]) ? $context["theme"] : null), "settings", array()), "navbar_position", array()))) : ("")), 5 => (($this->getAttribute(        // line 54
(isset($context["theme"]) ? $context["theme"] : null), "has_glyphicons", array())) ? ("has-glyphicons") : ("")));
        // line 57
        echo "<!DOCTYPE html>
<html ";
        // line 58
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["html_attributes"]) ? $context["html_attributes"] : null), "html", null, true));
        echo ">
  <head>
    <head-placeholder token=\"";
        // line 60
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar((isset($context["placeholder_token"]) ? $context["placeholder_token"] : null)));
        echo "\">
    <title>";
        // line 61
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar($this->env->getExtension('drupal_core')->safeJoin($this->env, (isset($context["head_title"]) ? $context["head_title"] : null), " | ")));
        echo "</title>
    <css-placeholder token=\"";
        // line 62
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar((isset($context["placeholder_token"]) ? $context["placeholder_token"] : null)));
        echo "\">
    <js-placeholder token=\"";
        // line 63
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar((isset($context["placeholder_token"]) ? $context["placeholder_token"] : null)));
        echo "\">
  </head>
  <body";
        // line 65
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["body_classes"]) ? $context["body_classes"] : null)), "method"), "html", null, true));
        echo ">
    <a href=\"#main-content\" class=\"visually-hidden focusable skip-link\">
      ";
        // line 67
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Skip to main content")));
        echo "
    </a>
    ";
        // line 69
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["page_top"]) ? $context["page_top"] : null), "html", null, true));
        echo "
    ";
        // line 70
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["page"]) ? $context["page"] : null), "html", null, true));
        echo "
    ";
        // line 71
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["page_bottom"]) ? $context["page_bottom"] : null), "html", null, true));
        echo "
    <js-bottom-placeholder token=\"";
        // line 72
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar((isset($context["placeholder_token"]) ? $context["placeholder_token"] : null)));
        echo "\">
  </body>
</html>
";
        
        $__internal_c079a47588bbf060137179b79efb45a91268d786aec96798d7245c84016fed66->leave($__internal_c079a47588bbf060137179b79efb45a91268d786aec96798d7245c84016fed66_prof);

    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/system/html.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  101 => 72,  97 => 71,  93 => 70,  89 => 69,  84 => 67,  79 => 65,  74 => 63,  70 => 62,  66 => 61,  62 => 60,  57 => 58,  54 => 57,  52 => 54,  51 => 53,  50 => 52,  49 => 51,  48 => 50,  47 => 49,  46 => 48,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation to display the basic html structure of a single*/
/*  * Drupal page.*/
/*  **/
/*  * Variables:*/
/*  * - $css: An array of CSS files for the current page.*/
/*  * - $language: (object) The language the site is being displayed in.*/
/*  *   $language->language contains its textual representation.*/
/*  *   $language->dir contains the language direction. It will either be 'ltr' or*/
/*  *   'rtl'.*/
/*  * - $rdf_namespaces: All the RDF namespace prefixes used in the HTML document.*/
/*  * - $grddl_profile: A GRDDL profile allowing agents to extract the RDF data.*/
/*  * - $head_title: A modified version of the page title, for use in the TITLE*/
/*  *   tag.*/
/*  * - $head_title_array: (array) An associative array containing the string parts*/
/*  *   that were used to generate the $head_title variable, already prepared to be*/
/*  *   output as TITLE tag. The key/value pairs may contain one or more of the*/
/*  *   following, depending on conditions:*/
/*  *   - title: The title of the current page, if any.*/
/*  *   - name: The name of the site.*/
/*  *   - slogan: The slogan of the site, if any, and if there is no title.*/
/*  * - $head: Markup for the HEAD section (including meta tags, keyword tags, and*/
/*  *   so on).*/
/*  * - $styles: Style tags necessary to import all CSS files for the page.*/
/*  * - $scripts: Script tags necessary to load the JavaScript files and settings*/
/*  *   for the page.*/
/*  * - $page_top: Initial markup from any modules that have altered the*/
/*  *   page. This variable should always be output first, before all other dynamic*/
/*  *   content.*/
/*  * - $page: The rendered page content.*/
/*  * - $page_bottom: Final closing markup from any modules that have altered the*/
/*  *   page. This variable should always be output last, after all other dynamic*/
/*  *   content.*/
/*  * - $classes String of classes that can be used to style contextually through*/
/*  *   CSS.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see bootstrap_preprocess_html()*/
/*  * @see template_preprocess()*/
/*  * @see template_preprocess_html()*/
/*  * @see template_process()*/
/*  *//* */
/* #}*/
/* {%*/
/*   set body_classes = [*/
/*     logged_in ? 'user-logged-in',*/
/*     not root_path ? 'path-frontpage' : 'path-' ~ root_path|clean_class,*/
/*     node_type ? 'page-node-type-' ~ node_type|clean_class,*/
/*     db_offline ? 'db-offline',*/
/*     theme.settings.navbar_position ? 'navbar-is-' ~ theme.settings.navbar_position,*/
/*     theme.has_glyphicons ? 'has-glyphicons',*/
/*   ]*/
/* %}*/
/* <!DOCTYPE html>*/
/* <html {{ html_attributes }}>*/
/*   <head>*/
/*     <head-placeholder token="{{ placeholder_token|raw }}">*/
/*     <title>{{ head_title|safe_join(' | ') }}</title>*/
/*     <css-placeholder token="{{ placeholder_token|raw }}">*/
/*     <js-placeholder token="{{ placeholder_token|raw }}">*/
/*   </head>*/
/*   <body{{ attributes.addClass(body_classes) }}>*/
/*     <a href="#main-content" class="visually-hidden focusable skip-link">*/
/*       {{ 'Skip to main content'|t }}*/
/*     </a>*/
/*     {{ page_top }}*/
/*     {{ page }}*/
/*     {{ page_bottom }}*/
/*     <js-bottom-placeholder token="{{ placeholder_token|raw }}">*/
/*   </body>*/
/* </html>*/
/* */
