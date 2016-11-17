<?php

/* themes/bootstrap/templates/menu/menu--account.html.twig */
class __TwigTemplate_2a390d1cb2ab4c7b7e7f03d65b2cf792058b4f5061acca6414bf346d4b1846ed extends Twig_Template
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
        $__internal_468c1620ee1c29d19d48c0479980636691a543867852dfedc259ce96795c19b5 = $this->env->getExtension("native_profiler");
        $__internal_468c1620ee1c29d19d48c0479980636691a543867852dfedc259ce96795c19b5->enter($__internal_468c1620ee1c29d19d48c0479980636691a543867852dfedc259ce96795c19b5_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "themes/bootstrap/templates/menu/menu--account.html.twig"));

        $tags = array("import" => 18, "macro" => 26, "if" => 28, "for" => 34, "set" => 36);
        $filters = array();
        $functions = array("link" => 47);

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('import', 'macro', 'if', 'for', 'set'),
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

        // line 18
        $context["menus"] = $this;
        // line 19
        echo "
";
        // line 24
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar($context["menus"]->getmenu_links((isset($context["items"]) ? $context["items"] : null), (isset($context["attributes"]) ? $context["attributes"] : null), 0)));
        echo "

";
        
        $__internal_468c1620ee1c29d19d48c0479980636691a543867852dfedc259ce96795c19b5->leave($__internal_468c1620ee1c29d19d48c0479980636691a543867852dfedc259ce96795c19b5_prof);

    }

    // line 26
    public function getmenu_links($__items__ = null, $__attributes__ = null, $__menu_level__ = null, ...$__varargs__)
    {
        $context = $this->env->mergeGlobals(array(
            "items" => $__items__,
            "attributes" => $__attributes__,
            "menu_level" => $__menu_level__,
            "varargs" => $__varargs__,
        ));

        $blocks = array();

        ob_start();
        try {
            $__internal_dae4352dd49a309135fdc4728dc190252cfbec2ee2dc5eb90c969100c7ea8566 = $this->env->getExtension("native_profiler");
            $__internal_dae4352dd49a309135fdc4728dc190252cfbec2ee2dc5eb90c969100c7ea8566->enter($__internal_dae4352dd49a309135fdc4728dc190252cfbec2ee2dc5eb90c969100c7ea8566_prof = new Twig_Profiler_Profile($this->getTemplateName(), "macro", "menu_links"));

            // line 27
            echo "  ";
            $context["menus"] = $this;
            // line 28
            echo "  ";
            if ((isset($context["items"]) ? $context["items"] : null)) {
                // line 29
                echo "    ";
                if (((isset($context["menu_level"]) ? $context["menu_level"] : null) == 0)) {
                    // line 30
                    echo "      <ul";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => "menu", 1 => "nav", 2 => "navbar-nav", 3 => "navbar-right"), "method"), "html", null, true));
                    echo ">
    ";
                } else {
                    // line 32
                    echo "      <ul";
                    echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => "dropdown-menu"), "method"), "html", null, true));
                    echo ">
    ";
                }
                // line 34
                echo "    ";
                $context['_parent'] = $context;
                $context['_seq'] = twig_ensure_traversable((isset($context["items"]) ? $context["items"] : null));
                foreach ($context['_seq'] as $context["_key"] => $context["item"]) {
                    // line 35
                    echo "      ";
                    // line 36
                    $context["item_classes"] = array(0 => "expanded", 1 => "dropdown", 2 => (($this->getAttribute(                    // line 39
$context["item"], "in_active_trail", array())) ? ("active") : ("")));
                    // line 42
                    echo "      ";
                    if ((((isset($context["menu_level"]) ? $context["menu_level"] : null) == 0) && $this->getAttribute($context["item"], "is_expanded", array()))) {
                        // line 43
                        echo "        <li";
                        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute($context["item"], "attributes", array()), "addClass", array(0 => (isset($context["item_classes"]) ? $context["item_classes"] : null)), "method"), "html", null, true));
                        echo ">
        <a href=\"";
                        // line 44
                        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["item"], "url", array()), "html", null, true));
                        echo "\" class=\"dropdown-toggle\" data-target=\"#\" data-toggle=\"dropdown\">";
                        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($context["item"], "title", array()), "html", null, true));
                        echo " <span class=\"caret\"></span></a>
      ";
                    } else {
                        // line 46
                        echo "        <li";
                        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute($context["item"], "attributes", array()), "addClass", array(0 => (isset($context["item_classes"]) ? $context["item_classes"] : null)), "method"), "html", null, true));
                        echo ">
        ";
                        // line 47
                        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->env->getExtension('drupal_core')->getLink($this->getAttribute($context["item"], "title", array()), $this->getAttribute($context["item"], "url", array())), "html", null, true));
                        echo "
      ";
                    }
                    // line 49
                    echo "      ";
                    if ($this->getAttribute($context["item"], "below", array())) {
                        // line 50
                        echo "        ";
                        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->renderVar($context["menus"]->getmenu_links($this->getAttribute($context["item"], "below", array()), $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "removeClass", array(0 => "nav", 1 => "navbar-nav", 2 => "navbar-right"), "method"), ((isset($context["menu_level"]) ? $context["menu_level"] : null) + 1))));
                        echo "
      ";
                    }
                    // line 52
                    echo "      </li>
    ";
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['item'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
                // line 54
                echo "    </ul>
  ";
            }
            
            $__internal_dae4352dd49a309135fdc4728dc190252cfbec2ee2dc5eb90c969100c7ea8566->leave($__internal_dae4352dd49a309135fdc4728dc190252cfbec2ee2dc5eb90c969100c7ea8566_prof);

        } catch (Exception $e) {
            ob_end_clean();

            throw $e;
        }

        return ('' === $tmp = ob_get_clean()) ? '' : new Twig_Markup($tmp, $this->env->getCharset());
    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/menu/menu--account.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  150 => 54,  143 => 52,  137 => 50,  134 => 49,  129 => 47,  124 => 46,  117 => 44,  112 => 43,  109 => 42,  107 => 39,  106 => 36,  104 => 35,  99 => 34,  93 => 32,  87 => 30,  84 => 29,  81 => 28,  78 => 27,  61 => 26,  51 => 24,  48 => 19,  46 => 18,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation to display a menu.*/
/*  **/
/*  * Available variables:*/
/*  * - menu_name: The machine name of the menu.*/
/*  * - items: A nested list of menu items. Each menu item contains:*/
/*  *   - attributes: HTML attributes for the menu item.*/
/*  *   - below: The menu item child items.*/
/*  *   - title: The menu link title.*/
/*  *   - url: The menu link url, instance of \Drupal\Core\Url*/
/*  *   - localized_options: Menu link localized options.*/
/*  **/
/*  * @ingroup templates*/
/*  *//* */
/* #}*/
/* {% import _self as menus %}*/
/* */
/* {#*/
/*   We call a macro which calls itself to render the full tree.*/
/*   @see http://twig.sensiolabs.org/doc/tags/macro.html*/
/* #}*/
/* {{ menus.menu_links(items, attributes, 0) }}*/
/* */
/* {% macro menu_links(items, attributes, menu_level) %}*/
/*   {% import _self as menus %}*/
/*   {% if items %}*/
/*     {% if menu_level == 0 %}*/
/*       <ul{{ attributes.addClass('menu', 'nav', 'navbar-nav', 'navbar-right') }}>*/
/*     {% else %}*/
/*       <ul{{ attributes.addClass('dropdown-menu') }}>*/
/*     {% endif %}*/
/*     {% for item in items %}*/
/*       {%*/
/*         set item_classes = [*/
/*           'expanded',*/
/*           'dropdown',*/
/*           item.in_active_trail ? 'active',*/
/*         ]*/
/*       %}*/
/*       {% if menu_level == 0 and item.is_expanded %}*/
/*         <li{{ item.attributes.addClass(item_classes) }}>*/
/*         <a href="{{ item.url }}" class="dropdown-toggle" data-target="#" data-toggle="dropdown">{{ item.title }} <span class="caret"></span></a>*/
/*       {% else %}*/
/*         <li{{ item.attributes.addClass(item_classes) }}>*/
/*         {{ link(item.title, item.url) }}*/
/*       {% endif %}*/
/*       {% if item.below %}*/
/*         {{ menus.menu_links(item.below, attributes.removeClass('nav', 'navbar-nav', 'navbar-right'), menu_level + 1) }}*/
/*       {% endif %}*/
/*       </li>*/
/*     {% endfor %}*/
/*     </ul>*/
/*   {% endif %}*/
/* {% endmacro %}*/
/* */
