<?php

/* themes/bootstrap/templates/system/status-messages.html.twig */
class __TwigTemplate_e83d9ddabe28b18bb9cc90463e3aa1a1a07f1b4f2e75a72e988f27ec899ab887 extends Twig_Template
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
        $__internal_fe71d9f49faa63347e920fc577c68c71217f7e9e80ef962147cc3598841cf8ab = $this->env->getExtension("native_profiler");
        $__internal_fe71d9f49faa63347e920fc577c68c71217f7e9e80ef962147cc3598841cf8ab->enter($__internal_fe71d9f49faa63347e920fc577c68c71217f7e9e80ef962147cc3598841cf8ab_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "themes/bootstrap/templates/system/status-messages.html.twig"));

        $tags = array("set" => 29, "for" => 44, "if" => 54);
        $filters = array("t" => 30, "length" => 57, "first" => 64);
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('set', 'for', 'if'),
                array('t', 'length', 'first'),
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

        // line 29
        $context["status_heading"] = array("status" => t("Status message"), "error" => t("Error message"), "warning" => t("Warning message"), "info" => t("Informative message"));
        // line 37
        $context["status_classes"] = array("status" => "success", "error" => "danger", "warning" => "warning", "info" => "info");
        // line 44
        $context['_parent'] = $context;
        $context['_seq'] = twig_ensure_traversable((isset($context["message_list"]) ? $context["message_list"] : null));
        foreach ($context['_seq'] as $context["type"] => $context["messages"]) {
            // line 46
            $context["classes"] = array(0 => "alert", 1 => ("alert-" . $this->getAttribute(            // line 48
(isset($context["status_classes"]) ? $context["status_classes"] : null), $context["type"], array(), "array")), 2 => "alert-dismissible");
            // line 52
            echo "<div";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
            echo " role=\"alert\">
  <a href=\"#\" role=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"";
            // line 53
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar(t("Close")));
            echo "\"><span aria-hidden=\"true\">&times;</span></a>
  ";
            // line 54
            if ($this->getAttribute((isset($context["status_headings"]) ? $context["status_headings"] : null), $context["type"], array(), "array")) {
                // line 55
                echo "    <h4 class=\"sr-only\">";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["status_headings"]) ? $context["status_headings"] : null), $context["type"], array(), "array"), "html", null, true));
                echo "</h4>
  ";
            }
            // line 57
            echo "  ";
            if ((twig_length_filter($this->env, $context["messages"]) > 1)) {
                // line 58
                echo "    <ul class=\"item-list item-list--messages\">
      ";
                // line 59
                $context['_parent'] = $context;
                $context['_seq'] = twig_ensure_traversable($context["messages"]);
                foreach ($context['_seq'] as $context["_key"] => $context["message"]) {
                    // line 60
                    echo "        <li class=\"item item--message\">";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $context["message"], "html", null, true));
                    echo "</li>
      ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['message'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 62
                echo "    </ul>
  ";
            } else {
                // line 64
                echo "    ";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, twig_first($this->env, $context["messages"]), "html", null, true));
                echo "
  ";
            }
            // line 66
            echo "</div>
";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['type'], $context['messages'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        
        $__internal_fe71d9f49faa63347e920fc577c68c71217f7e9e80ef962147cc3598841cf8ab->leave($__internal_fe71d9f49faa63347e920fc577c68c71217f7e9e80ef962147cc3598841cf8ab_prof);

    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/system/status-messages.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  103 => 66,  97 => 64,  93 => 62,  84 => 60,  80 => 59,  77 => 58,  74 => 57,  68 => 55,  66 => 54,  62 => 53,  57 => 52,  55 => 48,  54 => 46,  50 => 44,  48 => 37,  46 => 29,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for status messages.*/
/*  **/
/*  * Displays status, error, and warning messages, grouped by type.*/
/*  **/
/*  * An invisible heading identifies the messages for assistive technology.*/
/*  * Sighted users see a colored box. See http://www.w3.org/TR/WCAG-TECHS/H69.html*/
/*  * for info.*/
/*  **/
/*  * Add an ARIA label to the contentinfo area so that assistive technology*/
/*  * user agents will better describe this landmark.*/
/*  **/
/*  * Available variables:*/
/*  * - message_list: List of messages to be displayed, grouped by type.*/
/*  * - status_headings: List of all status types.*/
/*  * - display: (optional) May have a value of 'status' or 'error' when only*/
/*  *   displaying messages of that specific type.*/
/*  * - attributes: HTML attributes for the element, including:*/
/*  *   - class: HTML classes.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see template_preprocess_status_messages()*/
/*  *//* */
/* #}*/
/* {%*/
/*   set status_heading = {*/
/*     'status': 'Status message'|t,*/
/*     'error': 'Error message'|t,*/
/*     'warning': 'Warning message'|t,*/
/*     'info': 'Informative message'|t,*/
/*   }*/
/* %}*/
/* {%*/
/*   set status_classes = {*/
/*     'status': 'success',*/
/*     'error': 'danger',*/
/*     'warning': 'warning',*/
/*     'info': 'info',*/
/*   }*/
/* %}*/
/* {% for type, messages in message_list %}*/
/* {%*/
/*   set classes = [*/
/*     'alert',*/
/*     'alert-' ~ status_classes[type],*/
/*     'alert-dismissible',*/
/*   ]*/
/* %}*/
/* <div{{ attributes.addClass(classes) }} role="alert">*/
/*   <a href="#" role="button" class="close" data-dismiss="alert" aria-label="{{ 'Close'|t }}"><span aria-hidden="true">&times;</span></a>*/
/*   {% if status_headings[type] %}*/
/*     <h4 class="sr-only">{{ status_headings[type] }}</h4>*/
/*   {% endif %}*/
/*   {% if messages|length > 1 %}*/
/*     <ul class="item-list item-list--messages">*/
/*       {% for message in messages %}*/
/*         <li class="item item--message">{{ message }}</li>*/
/*       {% endfor %}*/
/*     </ul>*/
/*   {% else %}*/
/*     {{ messages|first }}*/
/*   {% endif %}*/
/* </div>*/
/* {% endfor %}*/
/* */
