<?php

/* themes/bootstrap/templates/input/select.html.twig */
class __TwigTemplate_cad46edca3ce11dc8fadde97ac15e5ee8f40c8f4a8c86aa98dacdcc53301da4e extends Twig_Template
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
        $tags = array("spaceless" => 18, "if" => 19, "set" => 34, "for" => 36);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('spaceless', 'if', 'set', 'for'),
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

        // line 18
        ob_start();
        // line 19
        echo "  ";
        if ((isset($context["input_group"]) ? $context["input_group"] : null)) {
            // line 20
            echo "    <div class=\"input-group\">
  ";
        }
        // line 22
        echo "
  ";
        // line 23
        if ((isset($context["prefix"]) ? $context["prefix"] : null)) {
            // line 24
            echo "    ";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["prefix"]) ? $context["prefix"] : null), "html", null, true));
            echo "
  ";
        }
        // line 26
        echo "
  ";
        // line 31
        echo "  ";
        if ( !$this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "offsetExists", array(0 => "multiple"), "method")) {
            // line 32
            echo "    <div class=\"select-wrapper\">
  ";
        }
        // line 34
        echo "    ";
        $context["classes"] = array(0 => "form-control");
        // line 35
        echo "    <select";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
        echo ">
      ";
        // line 36
        $context['_parent'] = $context;
        $context['_seq'] = twig_ensure_traversable((isset($context["options"]) ? $context["options"] : null));
        foreach ($context['_seq'] as $context["_key"] => $context["option"]) {
            // line 37
            echo "        ";
            if (($this->getAttribute($context["option"], "type", array()) == "optgroup")) {
                // line 38
                echo "          <optgroup label=\"";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["option"], "label", array()), "html", null, true));
                echo "\">
            ";
                // line 39
                $context['_parent'] = $context;
                $context['_seq'] = twig_ensure_traversable($this->getAttribute($context["option"], "options", array()));
                foreach ($context['_seq'] as $context["_key"] => $context["sub_option"]) {
                    // line 40
                    echo "              <option
                value=\"";
                    // line 41
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["sub_option"], "value", array()), "html", null, true));
                    echo "\"";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar((($this->getAttribute($context["sub_option"], "selected", array())) ? (" selected=\"selected\"") : (""))));
                    echo ">";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["sub_option"], "label", array()), "html", null, true));
                    echo "</option>
            ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['sub_option'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 43
                echo "          </optgroup>
        ";
            } elseif (($this->getAttribute(            // line 44
$context["option"], "type", array()) == "option")) {
                // line 45
                echo "          <option
            value=\"";
                // line 46
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["option"], "value", array()), "html", null, true));
                echo "\"";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar((($this->getAttribute($context["option"], "selected", array())) ? (" selected=\"selected\"") : (""))));
                echo ">";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["option"], "label", array()), "html", null, true));
                echo "</option>
        ";
            }
            // line 48
            echo "      ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['option'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 49
        echo "    </select>
  ";
        // line 50
        if ( !$this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "offsetExists", array(0 => "multiple"), "method")) {
            // line 51
            echo "    </div>
  ";
        }
        // line 53
        echo "
  ";
        // line 54
        if ((isset($context["suffix"]) ? $context["suffix"] : null)) {
            // line 55
            echo "    ";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["suffix"]) ? $context["suffix"] : null), "html", null, true));
            echo "
  ";
        }
        // line 57
        echo "
  ";
        // line 58
        if ((isset($context["input_group"]) ? $context["input_group"] : null)) {
            // line 59
            echo "    </div>
  ";
        }
        echo trim(preg_replace('/>\s+</', '><', ob_get_clean()));
    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/input/select.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  160 => 59,  158 => 58,  155 => 57,  149 => 55,  147 => 54,  144 => 53,  140 => 51,  138 => 50,  135 => 49,  129 => 48,  120 => 46,  117 => 45,  115 => 44,  112 => 43,  100 => 41,  97 => 40,  93 => 39,  88 => 38,  85 => 37,  81 => 36,  76 => 35,  73 => 34,  69 => 32,  66 => 31,  63 => 26,  57 => 24,  55 => 23,  52 => 22,  48 => 20,  45 => 19,  43 => 18,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Theme override for a select element.*/
/*  **/
/*  * Available variables:*/
/*  * - attributes: HTML attributes for the select tag.*/
/*  * - input_group: Flag to display as an input group.*/
/*  * - options: The option element children.*/
/*  * - prefix: Markup to display before the input element.*/
/*  * - suffix: Markup to display after the input element.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see template_preprocess_select()*/
/*  *//* */
/* #}*/
/* {% spaceless %}*/
/*   {% if input_group %}*/
/*     <div class="input-group">*/
/*   {% endif %}*/
/* */
/*   {% if prefix %}*/
/*     {{ prefix }}*/
/*   {% endif %}*/
/* */
/*   {# Browsers do not recognize pseudo :after selectors, we must create a wrapper*/
/*    # around the select element to style it properly.*/
/*    # @see http://stackoverflow.com/q/21103542*/
/*    #}*/
/*   {% if not attributes.offsetExists('multiple') %}*/
/*     <div class="select-wrapper">*/
/*   {% endif %}*/
/*     {% set classes = ['form-control'] %}*/
/*     <select{{ attributes.addClass(classes) }}>*/
/*       {% for option in options %}*/
/*         {% if option.type == 'optgroup' %}*/
/*           <optgroup label="{{ option.label }}">*/
/*             {% for sub_option in option.options %}*/
/*               <option*/
/*                 value="{{ sub_option.value }}"{{ sub_option.selected ? ' selected="selected"' }}>{{ sub_option.label }}</option>*/
/*             {% endfor %}*/
/*           </optgroup>*/
/*         {% elseif option.type == 'option' %}*/
/*           <option*/
/*             value="{{ option.value }}"{{ option.selected ? ' selected="selected"' }}>{{ option.label }}</option>*/
/*         {% endif %}*/
/*       {% endfor %}*/
/*     </select>*/
/*   {% if not attributes.offsetExists('multiple') %}*/
/*     </div>*/
/*   {% endif %}*/
/* */
/*   {% if suffix %}*/
/*     {{ suffix }}*/
/*   {% endif %}*/
/* */
/*   {% if input_group %}*/
/*     </div>*/
/*   {% endif %}*/
/* {% endspaceless %}*/
/* */
