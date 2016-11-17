<?php

/* core/modules/system/templates/block--system-menu-block.html.twig */
class __TwigTemplate_6ad75ae91ecb1bfc762058e83b35dc128a054517107d112562418026c8d964e5 extends Twig_Template
{
    public function __construct(Twig_Environment $env)
    {
        parent::__construct($env);

        $this->parent = false;

        $this->blocks = array(
            'content' => array($this, 'block_content'),
        );
    }

    protected function doDisplay(array $context, array $blocks = array())
    {
        $__internal_e12d2afbeb4a54672178ce494722c3f50c5d5024ac140afe6db4d41e4396e72f = $this->env->getExtension("native_profiler");
        $__internal_e12d2afbeb4a54672178ce494722c3f50c5d5024ac140afe6db4d41e4396e72f->enter($__internal_e12d2afbeb4a54672178ce494722c3f50c5d5024ac140afe6db4d41e4396e72f_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "core/modules/system/templates/block--system-menu-block.html.twig"));

        $tags = array("set" => 36, "if" => 39, "block" => 47);
        $filters = array("clean_id" => 36, "without" => 37);
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('set', 'if', 'block'),
                array('clean_id', 'without'),
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

        // line 36
        $context["heading_id"] = ($this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "id", array()) . \Drupal\Component\Utility\Html::getId("-menu"));
        // line 37
        echo "<nav role=\"navigation\" aria-labelledby=\"";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["heading_id"]) ? $context["heading_id"] : null), "html", null, true));
        echo "\"";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, twig_without((isset($context["attributes"]) ? $context["attributes"] : null), "role", "aria-labelledby"), "html", null, true));
        echo ">
  ";
        // line 39
        echo "  ";
        if ( !$this->getAttribute((isset($context["configuration"]) ? $context["configuration"] : null), "label_display", array())) {
            // line 40
            echo "    ";
            $context["title_attributes"] = $this->getAttribute((isset($context["title_attributes"]) ? $context["title_attributes"] : null), "addClass", array(0 => "visually-hidden"), "method");
            // line 41
            echo "  ";
        }
        // line 42
        echo "  ";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["title_prefix"]) ? $context["title_prefix"] : null), "html", null, true));
        echo "
  <h2";
        // line 43
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["title_attributes"]) ? $context["title_attributes"] : null), "setAttribute", array(0 => "id", 1 => (isset($context["heading_id"]) ? $context["heading_id"] : null)), "method"), "html", null, true));
        echo ">";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["configuration"]) ? $context["configuration"] : null), "label", array()), "html", null, true));
        echo "</h2>
  ";
        // line 44
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["title_suffix"]) ? $context["title_suffix"] : null), "html", null, true));
        echo "

  ";
        // line 47
        echo "  ";
        $this->displayBlock('content', $context, $blocks);
        // line 50
        echo "</nav>
";
        
        $__internal_e12d2afbeb4a54672178ce494722c3f50c5d5024ac140afe6db4d41e4396e72f->leave($__internal_e12d2afbeb4a54672178ce494722c3f50c5d5024ac140afe6db4d41e4396e72f_prof);

    }

    // line 47
    public function block_content($context, array $blocks = array())
    {
        $__internal_b3d5f655e354c2bea64f33ce8b70ca981a9ec595b40e7be660cf4828a4e68d61 = $this->env->getExtension("native_profiler");
        $__internal_b3d5f655e354c2bea64f33ce8b70ca981a9ec595b40e7be660cf4828a4e68d61->enter($__internal_b3d5f655e354c2bea64f33ce8b70ca981a9ec595b40e7be660cf4828a4e68d61_prof = new Twig_Profiler_Profile($this->getTemplateName(), "block", "content"));

        // line 48
        echo "    ";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["content"]) ? $context["content"] : null), "html", null, true));
        echo "
  ";
        
        $__internal_b3d5f655e354c2bea64f33ce8b70ca981a9ec595b40e7be660cf4828a4e68d61->leave($__internal_b3d5f655e354c2bea64f33ce8b70ca981a9ec595b40e7be660cf4828a4e68d61_prof);

    }

    public function getTemplateName()
    {
        return "core/modules/system/templates/block--system-menu-block.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  98 => 48,  92 => 47,  84 => 50,  81 => 47,  76 => 44,  70 => 43,  65 => 42,  62 => 41,  59 => 40,  56 => 39,  49 => 37,  47 => 36,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for a menu block.*/
/*  **/
/*  * Available variables:*/
/*  * - plugin_id: The ID of the block implementation.*/
/*  * - label: The configured label of the block if visible.*/
/*  * - configuration: A list of the block's configuration values.*/
/*  *   - label: The configured label for the block.*/
/*  *   - label_display: The display settings for the label.*/
/*  *   - provider: The module or other provider that provided this block plugin.*/
/*  *   - Block plugin specific settings will also be stored here.*/
/*  * - content: The content of this block.*/
/*  * - attributes: HTML attributes for the containing element.*/
/*  *   - id: A valid HTML ID and guaranteed unique.*/
/*  * - title_attributes: HTML attributes for the title element.*/
/*  * - content_attributes: HTML attributes for the content element.*/
/*  * - title_prefix: Additional output populated by modules, intended to be*/
/*  *   displayed in front of the main title tag that appears in the template.*/
/*  * - title_suffix: Additional output populated by modules, intended to be*/
/*  *   displayed after the main title tag that appears in the template.*/
/*  **/
/*  * Headings should be used on navigation menus that consistently appear on*/
/*  * multiple pages. When this menu block's label is configured to not be*/
/*  * displayed, it is automatically made invisible using the 'visually-hidden' CSS*/
/*  * class, which still keeps it visible for screen-readers and assistive*/
/*  * technology. Headings allow screen-reader and keyboard only users to navigate*/
/*  * to or skip the links.*/
/*  * See http://juicystudio.com/article/screen-readers-display-none.php and*/
/*  * http://www.w3.org/TR/WCAG-TECHS/H42.html for more information.*/
/*  **/
/*  * @ingroup themeable*/
/*  *//* */
/* #}*/
/* {% set heading_id = attributes.id ~ '-menu'|clean_id %}*/
/* <nav role="navigation" aria-labelledby="{{ heading_id }}"{{ attributes|without('role', 'aria-labelledby') }}>*/
/*   {# Label. If not displayed, we still provide it for screen readers. #}*/
/*   {% if not configuration.label_display %}*/
/*     {% set title_attributes = title_attributes.addClass('visually-hidden') %}*/
/*   {% endif %}*/
/*   {{ title_prefix }}*/
/*   <h2{{ title_attributes.setAttribute('id', heading_id) }}>{{ configuration.label }}</h2>*/
/*   {{ title_suffix }}*/
/* */
/*   {# Menu. #}*/
/*   {% block content %}*/
/*     {{ content }}*/
/*   {% endblock %}*/
/* </nav>*/
/* */
