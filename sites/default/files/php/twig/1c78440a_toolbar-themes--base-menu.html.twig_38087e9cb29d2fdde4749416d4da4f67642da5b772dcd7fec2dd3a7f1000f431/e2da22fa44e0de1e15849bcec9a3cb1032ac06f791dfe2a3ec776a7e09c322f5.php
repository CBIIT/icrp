<?php

/* modules/toolbar_themes/themes/base/templates/toolbar-themes--base-menu.html.twig */
class __TwigTemplate_9069e5b4bf21fb19fe811df13e559086bfda8282d7c319caac144f0d4a947c72 extends Twig_Template
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
        $tags = array("import" => 23, "macro" => 29, "if" => 31, "for" => 32, "set" => 45);
        $filters = array("clean_class" => 37, "without" => 57, "render" => 57);
        $functions = array("cycle" => 39, "link" => 58);

        try {
            $this->env->getExtension('Twig_Extension_Sandbox')->checkSecurity(
                array('import', 'macro', 'if', 'for', 'set'),
                array('clean_class', 'without', 'render'),
                array('cycle', 'link')
            );
        } catch (Twig_Sandbox_SecurityError $e) {
            $e->setSourceContext($this->getSourceContext());

            if ($e instanceof Twig_Sandbox_SecurityNotAllowedTagError && isset($tags[$e->getTagName()])) {
                $e->setTemplateLine($tags[$e->getTagName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFilterError && isset($filters[$e->getFilterName()])) {
                $e->setTemplateLine($filters[$e->getFilterName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFunctionError && isset($functions[$e->getFunctionName()])) {
                $e->setTemplateLine($functions[$e->getFunctionName()]);
            }

            throw $e;
        }

        // line 23
        $context["menus"] = $this;
        // line 28
        echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->renderVar($context["menus"]->getmenu_links(($context["items"] ?? null), ($context["attributes"] ?? null), 0, ($context["menu_name"] ?? null))));
    }

    // line 29
    public function getmenu_links($__items__ = null, $__attributes__ = null, $__menu_level__ = null, $__menu_name__ = null, ...$__varargs__)
    {
        $context = $this->env->mergeGlobals(array(
            "items" => $__items__,
            "attributes" => $__attributes__,
            "menu_level" => $__menu_level__,
            "menu_name" => $__menu_name__,
            "varargs" => $__varargs__,
        ));

        $blocks = array();

        ob_start();
        try {
            // line 30
            $context["menus"] = $this;
            // line 31
            if (($context["items"] ?? null)) {
                // line 32
                $context['_parent'] = $context;
                $context['_seq'] = twig_ensure_traversable(($context["items"] ?? null));
                $context['loop'] = array(
                  'parent' => $context['_parent'],
                  'index0' => 0,
                  'index'  => 1,
                  'first'  => true,
                );
                if (is_array($context['_seq']) || (is_object($context['_seq']) && $context['_seq'] instanceof Countable)) {
                    $length = count($context['_seq']);
                    $context['loop']['revindex0'] = $length - 1;
                    $context['loop']['revindex'] = $length;
                    $context['loop']['length'] = $length;
                    $context['loop']['last'] = 1 === $length;
                }
                foreach ($context['_seq'] as $context["_key"] => $context["item"]) {
                    // line 34
                    if ($this->getAttribute($context["loop"], "first", array())) {
                        // line 35
                        echo "        <ul";
                        // line 36
                        if ((($context["menu_level"] ?? null) == 0)) {
                            // line 37
                            echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, $this->getAttribute(($context["attributes"] ?? null), "addClass", array(0 => array(0 => "toolbar-menu", 1 => "odd", 2 => "menu-level-1", 3 => ((($context["menu_name"] ?? null)) ? (("menu-name--" . \Drupal\Component\Utility\Html::getClass(($context["menu_name"] ?? null)))) : ("")))), "method"), "html", null, true));
                        } else {
                            // line 39
                            echo "          class=\"toolbar-menu is-child ";
                            echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, twig_cycle(array(0 => "odd", 1 => "even"), ($context["menu_level"] ?? null)), "html", null, true));
                            echo " ";
                            echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, ("menu-level-" . (($context["menu_level"] ?? null) + 1)), "html", null, true));
                            echo "\"";
                        }
                        // line 41
                        echo ">
      ";
                    }
                    // line 44
                    if ( !twig_test_empty($this->getAttribute($context["item"], "below", array()))) {
                        // line 45
                        $context["is_parent"] = true;
                    } else {
                        // line 47
                        $context["is_parent"] = false;
                    }
                    // line 49
                    $context["item_classes"] = array(0 => "menu-item", 1 => ((                    // line 51
($context["is_parent"] ?? null)) ? ("is-parent") : ("")), 2 => (($this->getAttribute(                    // line 52
$context["item"], "is_expanded", array())) ? ("menu-item--expanded") : ("")), 3 => (($this->getAttribute(                    // line 53
$context["item"], "is_collapsed", array())) ? ("menu-item--collapsed") : ("")), 4 => (($this->getAttribute(                    // line 54
$context["item"], "in_active_trail", array())) ? ("menu-tem--active-trail") : ("")));
                    // line 57
                    echo "      <li";
                    echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, twig_without($this->getAttribute($this->getAttribute($this->getAttribute($context["item"], "attributes", array()), "addClass", array(0 => ($context["item_classes"] ?? null)), "method"), "setAttribute", array(0 => "id", 1 => ("mlid-" . \Drupal\Component\Utility\Html::getClass($this->env->getExtension('Drupal\Core\Template\TwigExtension')->renderVar($this->getAttribute($context["item"], "title", array()))))), "method"), "role"), "html", null, true));
                    echo ">";
                    // line 58
                    echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, $this->env->getExtension('Drupal\Core\Template\TwigExtension')->getLink($this->getAttribute($context["item"], "title", array()), $this->getAttribute($context["item"], "url", array())), "html", null, true));
                    // line 59
                    if ($this->getAttribute($context["item"], "show_icon", array())) {
                        // line 60
                        if ($this->getAttribute($context["item"], "icon_attributes", array())) {
                            // line 61
                            echo "<i";
                            echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, $this->getAttribute($this->getAttribute($context["item"], "icon_attributes", array()), "setAttribute", array(0 => "data-grunticon-embed", 1 => ""), "method"), "html", null, true));
                            echo "></i>";
                        }
                    }
                    // line 64
                    if ($this->getAttribute($context["item"], "below", array())) {
                        // line 65
                        echo "          ";
                        echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->renderVar($context["menus"]->getmenu_links($this->getAttribute($context["item"], "below", array()), ($context["attributes"] ?? null), (($context["menu_level"] ?? null) + 1), ($context["menu_name"] ?? null))));
                        echo "
        ";
                    }
                    // line 67
                    echo "      </li>

      ";
                    // line 69
                    if ($this->getAttribute($context["loop"], "last", array())) {
                        // line 70
                        echo "        </ul>
      ";
                    }
                    ++$context['loop']['index0'];
                    ++$context['loop']['index'];
                    $context['loop']['first'] = false;
                    if (isset($context['loop']['length'])) {
                        --$context['loop']['revindex0'];
                        --$context['loop']['revindex'];
                        $context['loop']['last'] = 0 === $context['loop']['revindex0'];
                    }
                }
                $_parent = $context['_parent'];
                unset($context['_seq'], $context['_iterated'], $context['_key'], $context['item'], $context['_parent'], $context['loop']);
                $context = array_intersect_key($context, $_parent) + $_parent;
            }
        } catch (Exception $e) {
            ob_end_clean();

            throw $e;
        } catch (Throwable $e) {
            ob_end_clean();

            throw $e;
        }

        return ('' === $tmp = ob_get_clean()) ? '' : new Twig_Markup($tmp, $this->env->getCharset());
    }

    public function getTemplateName()
    {
        return "modules/toolbar_themes/themes/base/templates/toolbar-themes--base-menu.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  149 => 70,  147 => 69,  143 => 67,  137 => 65,  135 => 64,  129 => 61,  127 => 60,  125 => 59,  123 => 58,  119 => 57,  117 => 54,  116 => 53,  115 => 52,  114 => 51,  113 => 49,  110 => 47,  107 => 45,  105 => 44,  101 => 41,  94 => 39,  91 => 37,  89 => 36,  87 => 35,  85 => 34,  68 => 32,  66 => 31,  64 => 30,  49 => 29,  45 => 28,  43 => 23,);
    }

    /** @deprecated since 1.27 (to be removed in 2.0). Use getSourceContext() instead */
    public function getSource()
    {
        @trigger_error('The '.__METHOD__.' method is deprecated since version 1.27 and will be removed in 2.0. Use getSourceContext() instead.', E_USER_DEPRECATED);

        return $this->getSourceContext()->getCode();
    }

    public function getSourceContext()
    {
        return new Twig_Source("{#
/**
 * Toolbar themes theme implementation to display a toolbar menu.
 *
 * Available variables:
 * - menu_name: The machine name of the menu.
 * - items: A nested list of menu items. Each menu item contains:
 *   - attributes: HTML attributes for the menu item.
 *   - below: The menu item child items.
 *   - title: The menu link title.
 *   - url: The menu link url, instance of \\Drupal\\Core\\Url
 *   - localized_options: Menu link localized options.
 *   - is_expanded: TRUE if the link has visible children within the current
 *     menu tree.
 *   - is_collapsed: TRUE if the link has children within the current menu tree
 *     that are not currently visible.
 *   - in_active_trail: TRUE if the link is in the active trail.
 * - show_icon: bool to show or hide icon markup.
 *
 * @ingroup themeable
 */
#}
{%- import _self as menus -%}
{#
  We call a macro which calls itself to render the full tree.
  @see http://twig.sensiolabs.org/doc/tags/macro.html
#}
{{- menus.menu_links(items, attributes, 0, menu_name) -}}
{%- macro menu_links(items, attributes, menu_level, menu_name) -%}
  {%- import _self as menus -%}
  {% if items %}
    {%- for item in items -%}

      {% if loop.first %}
        <ul
        {%- if menu_level == 0 -%}
          {{ attributes.addClass(['toolbar-menu', 'odd', 'menu-level-1', menu_name ? 'menu-name--' ~ menu_name|clean_class ]) }}
        {%- else %}
          class=\"toolbar-menu is-child {{ cycle(['odd', 'even'], menu_level) }} {{ 'menu-level-' ~ (menu_level + 1) }}\"
        {%- endif -%}
        >
      {% endif %}

      {%- if item.below is not empty -%}
        {%- set is_parent = true -%}
      {%- else -%}
        {%- set is_parent = false -%}
      {%- endif -%}
      {%- set item_classes = [
        'menu-item',
        is_parent ? 'is-parent',
        item.is_expanded ? 'menu-item--expanded',
        item.is_collapsed ? 'menu-item--collapsed',
        item.in_active_trail ? 'menu-tem--active-trail',
      ] -%}
      {# We set an id on list items to provide context for aria attributes. #}
      <li{{ item.attributes.addClass(item_classes).setAttribute('id', 'mlid-' ~ item.title|render|clean_class)|without('role') }}>
        {{- link(item.title, item.url) -}}
        {%- if item.show_icon -%}
          {%- if item.icon_attributes -%}
            <i{{ item.icon_attributes.setAttribute('data-grunticon-embed', '') }}></i>
          {%- endif -%}
        {%- endif -%}
        {% if item.below %}
          {{ menus.menu_links(item.below, attributes, menu_level + 1, menu_name) }}
        {% endif %}
      </li>

      {% if loop.last %}
        </ul>
      {% endif %}

    {%- endfor -%}
  {% endif %}
{%- endmacro -%}
", "modules/toolbar_themes/themes/base/templates/toolbar-themes--base-menu.html.twig", "/github/drupal8.dev/sites/icrp/modules/toolbar_themes/themes/base/templates/toolbar-themes--base-menu.html.twig");
    }
}
