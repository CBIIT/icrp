<?php

/* modules/page_manager/page_manager_ui/templates/page-manager-wizard-tree.html.twig */
class __TwigTemplate_bf16888a26c8f1c3a502db815638146632ea11f56f0cb642df278cce39a26723 extends Twig_Template
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
        $__internal_a7408a651f9f5856df7c6281c3e504e45a847fa6d308945f7d20c70e42ae6619 = $this->env->getExtension("native_profiler");
        $__internal_a7408a651f9f5856df7c6281c3e504e45a847fa6d308945f7d20c70e42ae6619->enter($__internal_a7408a651f9f5856df7c6281c3e504e45a847fa6d308945f7d20c70e42ae6619_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "modules/page_manager/page_manager_ui/templates/page-manager-wizard-tree.html.twig"));

        $tags = array("import" => 17, "macro" => 25, "if" => 27, "for" => 29);
        $filters = array();
        $functions = array("link" => 33);

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('import', 'macro', 'if', 'for'),
                array(),
                array('link')
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

        // line 17
        $context["page_manager"] = $this;
        // line 18
        echo "
";
        // line 23
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar($context["page_manager"]->getwizard_tree((isset($context["tree"]) ? $context["tree"] : null), (isset($context["step"]) ? $context["step"] : null), 0)));
        echo "

";
        
        $__internal_a7408a651f9f5856df7c6281c3e504e45a847fa6d308945f7d20c70e42ae6619->leave($__internal_a7408a651f9f5856df7c6281c3e504e45a847fa6d308945f7d20c70e42ae6619_prof);

    }

    // line 25
    public function getwizard_tree($__items__ = null, $__step__ = null, $__menu_level__ = null, ...$__varargs__)
    {
        $context = $this->env->mergeGlobals(array(
            "items" => $__items__,
            "step" => $__step__,
            "menu_level" => $__menu_level__,
            "varargs" => $__varargs__,
        ));

        $blocks = array();

        ob_start();
        try {
            $__internal_76330212d0568a0ab91d20f7b1bdbaed70223fcbffde144ae9c101a3900e8ef9 = $this->env->getExtension("native_profiler");
            $__internal_76330212d0568a0ab91d20f7b1bdbaed70223fcbffde144ae9c101a3900e8ef9->enter($__internal_76330212d0568a0ab91d20f7b1bdbaed70223fcbffde144ae9c101a3900e8ef9_prof = new Twig_Profiler_Profile($this->getTemplateName(), "macro", "wizard_tree"));

            // line 26
            echo "  ";
            $context["page_manager"] = $this;
            // line 27
            echo "  ";
            if ((isset($context["items"]) ? $context["items"] : null)) {
                // line 28
                echo "    <ul>
    ";
                // line 29
                $context['_parent'] = $context;
                $context['_seq'] = twig_ensure_traversable((isset($context["items"]) ? $context["items"] : null));
                foreach ($context['_seq'] as $context["_key"] => $context["item"]) {
                    // line 30
                    echo "      <li>
        ";
                    // line 31
                    if ($this->getAttribute($context["item"], "url", array())) {
                        // line 32
                        echo "          ";
                        if (((isset($context["step"]) ? $context["step"] : null) === $this->getAttribute($context["item"], "step", array()))) {
                            // line 33
                            echo "            <strong>";
                            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->env->getExtension('drupal_core')->getLink($this->getAttribute($context["item"], "title", array()), $this->getAttribute($context["item"], "url", array())), "html", null, true));
                            echo "</strong>
          ";
                        } else {
                            // line 35
                            echo "            ";
                            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->env->getExtension('drupal_core')->getLink($this->getAttribute($context["item"], "title", array()), $this->getAttribute($context["item"], "url", array())), "html", null, true));
                            echo "
          ";
                        }
                        // line 37
                        echo "        ";
                    } else {
                        // line 38
                        echo "          ";
                        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["item"], "title", array()), "html", null, true));
                        echo "
        ";
                    }
                    // line 40
                    echo "        ";
                    if ($this->getAttribute($context["item"], "children", array())) {
                        // line 41
                        echo "          ";
                        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar($context["page_manager"]->getwizard_tree($this->getAttribute($context["item"], "children", array()), (isset($context["step"]) ? $context["step"] : null), ((isset($context["menu_level"]) ? $context["menu_level"] : null) + 1))));
                        echo "
        ";
                    }
                    // line 43
                    echo "      </li>
    ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['item'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 45
                echo "    </ul>
  ";
            }
            
            $__internal_76330212d0568a0ab91d20f7b1bdbaed70223fcbffde144ae9c101a3900e8ef9->leave($__internal_76330212d0568a0ab91d20f7b1bdbaed70223fcbffde144ae9c101a3900e8ef9_prof);

        } catch (Exception $e) {
            ob_end_clean();

            throw $e;
        }

        return ('' === $tmp = ob_get_clean()) ? '' : new Twig_Markup($tmp, $this->env->getCharset());
    }

    public function getTemplateName()
    {
        return "modules/page_manager/page_manager_ui/templates/page-manager-wizard-tree.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  136 => 45,  129 => 43,  123 => 41,  120 => 40,  114 => 38,  111 => 37,  105 => 35,  99 => 33,  96 => 32,  94 => 31,  91 => 30,  87 => 29,  84 => 28,  81 => 27,  78 => 26,  61 => 25,  51 => 23,  48 => 18,  46 => 17,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation to display wizard tree.*/
/*  **/
/*  * Available variables:*/
/*  * - step: The current step name.*/
/*  * - tree: A nested list of menu items. Each menu item contains:*/
/*  *   - title: The menu link title.*/
/*  *   - url: The menu link url, instance of \Drupal\Core\Url*/
/*  *   - children: The menu item child items.*/
/*  *   - step: The name of the step.*/
/*  **/
/*  * @ingroup themeable*/
/*  *//* */
/* #}*/
/* {% import _self as page_manager %}*/
/* */
/* {#*/
/*   We call a macro which calls itself to render the full tree.*/
/*   @see http://twig.sensiolabs.org/doc/tags/macro.html*/
/* #}*/
/* {{ page_manager.wizard_tree(tree, step, 0) }}*/
/* */
/* {% macro wizard_tree(items, step, menu_level) %}*/
/*   {% import _self as page_manager %}*/
/*   {% if items %}*/
/*     <ul>*/
/*     {% for item in items %}*/
/*       <li>*/
/*         {% if item.url %}*/
/*           {% if step is same as(item.step) %}*/
/*             <strong>{{ link(item.title, item.url) }}</strong>*/
/*           {% else %}*/
/*             {{ link(item.title, item.url) }}*/
/*           {% endif %}*/
/*         {% else %}*/
/*           {{ item.title }}*/
/*         {% endif %}*/
/*         {% if item.children %}*/
/*           {{ page_manager.wizard_tree(item.children, step, menu_level + 1) }}*/
/*         {% endif %}*/
/*       </li>*/
/*     {% endfor %}*/
/*     </ul>*/
/*   {% endif %}*/
/* {% endmacro %}*/
/* */
