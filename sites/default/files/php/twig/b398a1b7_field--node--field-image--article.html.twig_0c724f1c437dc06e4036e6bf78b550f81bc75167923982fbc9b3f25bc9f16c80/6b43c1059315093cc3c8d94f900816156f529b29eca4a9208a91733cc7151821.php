<?php

/* themes/bootstrap/templates/field/field--node--field-image--article.html.twig */
class __TwigTemplate_36b358c853c4c5edb9571b7922477b3897e5130c17aa35a1c6617c1a9190db54 extends Twig_Template
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
        $__internal_a819888b80d74a9629c225a938722cf1e4e566585098cb4cfe8766dfdf1f0caa = $this->env->getExtension("native_profiler");
        $__internal_a819888b80d74a9629c225a938722cf1e4e566585098cb4cfe8766dfdf1f0caa->enter($__internal_a819888b80d74a9629c225a938722cf1e4e566585098cb4cfe8766dfdf1f0caa_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "themes/bootstrap/templates/field/field--node--field-image--article.html.twig"));

        $tags = array("set" => 42, "if" => 57, "for" => 60);
        $filters = array("clean_class" => 44);
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('set', 'if', 'for'),
                array('clean_class'),
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

        // line 42
        $context["classes"] = array(0 => "field", 1 => ("field--name-" . \Drupal\Component\Utility\Html::getClass(        // line 44
(isset($context["field_name"]) ? $context["field_name"] : null))), 2 => ("field--type-" . \Drupal\Component\Utility\Html::getClass(        // line 45
(isset($context["field_type"]) ? $context["field_type"] : null))), 3 => ("field--label-" .         // line 46
(isset($context["label_display"]) ? $context["label_display"] : null)), 4 => "col-sm-4");
        // line 51
        $context["title_classes"] = array(0 => "field--label", 1 => (((        // line 53
(isset($context["label_display"]) ? $context["label_display"] : null) == "visually_hidden")) ? ("sr-only") : ("")));
        // line 56
        echo "
";
        // line 57
        if ((isset($context["label_hidden"]) ? $context["label_hidden"] : null)) {
            // line 58
            echo "  ";
            if ((isset($context["multiple"]) ? $context["multiple"] : null)) {
                // line 59
                echo "    <div";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null), 1 => "field--items"), "method"), "html", null, true));
                echo ">
      ";
                // line 60
                $context['_parent'] = $context;
                $context['_seq'] = twig_ensure_traversable((isset($context["items"]) ? $context["items"] : null));
                foreach ($context['_seq'] as $context["_key"] => $context["item"]) {
                    // line 61
                    echo "        <div";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute($context["item"], "attributes", array()), "addClass", array(0 => "field--item"), "method"), "html", null, true));
                    echo ">";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["item"], "content", array()), "html", null, true));
                    echo "</div>
      ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['item'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 63
                echo "    </div>
  ";
            } else {
                // line 65
                echo "    ";
                $context['_parent'] = $context;
                $context['_seq'] = twig_ensure_traversable((isset($context["items"]) ? $context["items"] : null));
                foreach ($context['_seq'] as $context["_key"] => $context["item"]) {
                    // line 66
                    echo "      <div";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null), 1 => "field--item"), "method"), "html", null, true));
                    echo ">";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["item"], "content", array()), "html", null, true));
                    echo "</div>
    ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['item'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 68
                echo "  ";
            }
        } else {
            // line 70
            echo "  <div";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
            echo ">
    <div";
            // line 71
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["title_attributes"]) ? $context["title_attributes"] : null), "addClass", array(0 => (isset($context["title_classes"]) ? $context["title_classes"] : null)), "method"), "html", null, true));
            echo ">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["label"]) ? $context["label"] : null), "html", null, true));
            echo "</div>
    ";
            // line 72
            if ((isset($context["multiple"]) ? $context["multiple"] : null)) {
                // line 73
                echo "      <div class=\"field__items\">
    ";
            }
            // line 75
            echo "    ";
            $context['_parent'] = $context;
            $context['_seq'] = twig_ensure_traversable((isset($context["items"]) ? $context["items"] : null));
            foreach ($context['_seq'] as $context["_key"] => $context["item"]) {
                // line 76
                echo "      <div";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute($context["item"], "attributes", array()), "addClass", array(0 => "field--item"), "method"), "html", null, true));
                echo ">";
                echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["item"], "content", array()), "html", null, true));
                echo "</div>
    ";
            }
            $_parent = $context['_parent'];
            unset($context['_seq'], $context['_iterated'], $context['_key'], $context['item'], $context['_parent'], $context['loop']);
            $context = array_intersect_key($context, $_parent) + $_parent;
            // line 78
            echo "    ";
            if ((isset($context["multiple"]) ? $context["multiple"] : null)) {
                // line 79
                echo "      </div>
    ";
            }
            // line 81
            echo "  </div>
";
        }
        
        $__internal_a819888b80d74a9629c225a938722cf1e4e566585098cb4cfe8766dfdf1f0caa->leave($__internal_a819888b80d74a9629c225a938722cf1e4e566585098cb4cfe8766dfdf1f0caa_prof);

    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/field/field--node--field-image--article.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  146 => 81,  142 => 79,  139 => 78,  128 => 76,  123 => 75,  119 => 73,  117 => 72,  111 => 71,  106 => 70,  102 => 68,  91 => 66,  86 => 65,  82 => 63,  71 => 61,  67 => 60,  62 => 59,  59 => 58,  57 => 57,  54 => 56,  52 => 53,  51 => 51,  49 => 46,  48 => 45,  47 => 44,  46 => 42,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Theme override for a field.*/
/*  **/
/*  * To override output, copy the "field.html.twig" from the templates directory*/
/*  * to your theme's directory and customize it, just like customizing other*/
/*  * Drupal templates such as page.html.twig or node.html.twig.*/
/*  **/
/*  * Instead of overriding the theming for all fields, you can also just override*/
/*  * theming for a subset of fields using*/
/*  * @link themeable Theme hook suggestions. @endlink For example,*/
/*  * here are some theme hook suggestions that can be used for a field_foo field*/
/*  * on an article node type:*/
/*  * - field--node--field-foo--article.html.twig*/
/*  * - field--node--field-foo.html.twig*/
/*  * - field--node--article.html.twig*/
/*  * - field--field-foo.html.twig*/
/*  * - field--text-with-summary.html.twig*/
/*  * - field.html.twig*/
/*  **/
/*  * Available variables:*/
/*  * - attributes: HTML attributes for the containing element.*/
/*  * - label_hidden: Whether to show the field label or not.*/
/*  * - title_attributes: HTML attributes for the title.*/
/*  * - label: The label for the field.*/
/*  * - multiple: TRUE if a field can contain multiple items.*/
/*  * - items: List of all the field items. Each item contains:*/
/*  *   - attributes: List of HTML attributes for each item.*/
/*  *   - content: The field item's content.*/
/*  * - entity_type: The entity type to which the field belongs.*/
/*  * - field_name: The name of the field.*/
/*  * - field_type: The type of the field.*/
/*  * - label_display: The display settings for the label.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see template_preprocess_field()*/
/*  *//* */
/* #}*/
/* {%*/
/*   set classes = [*/
/*     'field',*/
/*     'field--name-' ~ field_name|clean_class,*/
/*     'field--type-' ~ field_type|clean_class,*/
/*     'field--label-' ~ label_display,*/
/*     'col-sm-4',*/
/*   ]*/
/* %}*/
/* {%*/
/*   set title_classes = [*/
/*     'field--label',*/
/*     label_display == 'visually_hidden' ? 'sr-only',*/
/*   ]*/
/* %}*/
/* */
/* {% if label_hidden %}*/
/*   {% if multiple %}*/
/*     <div{{ attributes.addClass(classes, 'field--items') }}>*/
/*       {% for item in items %}*/
/*         <div{{ item.attributes.addClass('field--item') }}>{{ item.content }}</div>*/
/*       {% endfor %}*/
/*     </div>*/
/*   {% else %}*/
/*     {% for item in items %}*/
/*       <div{{ attributes.addClass(classes, 'field--item') }}>{{ item.content }}</div>*/
/*     {% endfor %}*/
/*   {% endif %}*/
/* {% else %}*/
/*   <div{{ attributes.addClass(classes) }}>*/
/*     <div{{ title_attributes.addClass(title_classes) }}>{{ label }}</div>*/
/*     {% if multiple %}*/
/*       <div class="field__items">*/
/*     {% endif %}*/
/*     {% for item in items %}*/
/*       <div{{ item.attributes.addClass('field--item') }}>{{ item.content }}</div>*/
/*     {% endfor %}*/
/*     {% if multiple %}*/
/*       </div>*/
/*     {% endif %}*/
/*   </div>*/
/* {% endif %}*/
/* */
