<?php

/* modules/toolbar_themes/themes/base/templates/toolbar-themes--base-toolbar.html.twig */
class __TwigTemplate_26d4e50ef5c1a0dd4358583e9e2733fd2bc29f0c68920de283e68cb92612e5dd extends Twig_Template
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
        $tags = array("set" => 28, "for" => 36, "if" => 41, "spaceless" => 47);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('Twig_Extension_Sandbox')->checkSecurity(
                array('set', 'for', 'if', 'spaceless'),
                array(),
                array()
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

        // line 26
        echo "<div";
        echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, $this->getAttribute(($context["attributes"] ?? null), "addClass", array(0 => "toolbar"), "method"), "html", null, true));
        echo ">
  ";
        // line 28
        $context["classes"] = array(0 => "toolbar-bar", 1 => ((        // line 30
($context["show_icons"] ?? null)) ? ("has-icons") : ("no-icons")), 2 => ((        // line 31
($context["show_tabs"] ?? null)) ? ("has-tabs") : ("no-tabs")));
        // line 34
        echo "  <nav";
        echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, $this->getAttribute($this->getAttribute(($context["toolbar_attributes"] ?? null), "addClass", array(0 => ($context["classes"] ?? null)), "method"), "setAttribute", array(0 => "style", 1 => ($context["font_size"] ?? null)), "method"), "html", null, true));
        echo ">
    <h2 class=\"visually-hidden\">";
        // line 35
        echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, ($context["toolbar_heading"] ?? null), "html", null, true));
        echo "</h2>
    ";
        // line 36
        $context['_parent'] = $context;
        $context['_seq'] = twig_ensure_traversable(($context["tabs"] ?? null));
        foreach ($context['_seq'] as $context["key"] => $context["tab"]) {
            // line 37
            echo "      ";
            $context["tray"] = $this->getAttribute(($context["trays"] ?? null), $context["key"], array(), "array");
            // line 38
            echo "      <div";
            echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, $this->getAttribute($this->getAttribute($context["tab"], "attributes", array()), "addClass", array(0 => "toolbar-tab"), "method"), "html", null, true));
            echo ">
        <span class=\"toolbar-tab__items-wrapper\">";
            // line 40
            echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, $this->getAttribute($context["tab"], "link", array()), "html", null, true));
            // line 41
            if ((($context["show_icons"] ?? null) && ($context["show_tabs"] ?? null))) {
                // line 42
                if ($this->getAttribute($context["tab"], "icon_attributes", array())) {
                    // line 43
                    echo "<i";
                    echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, $this->getAttribute($this->getAttribute($context["tab"], "icon_attributes", array()), "setAttribute", array(0 => "data-grunticon-embed", 1 => ""), "method"), "html", null, true));
                    echo "></i>";
                }
            }
            // line 46
            echo "</span>
        ";
            // line 47
            ob_start();
            // line 48
            echo "          <div";
            echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, $this->getAttribute(($context["tray"] ?? null), "attributes", array()), "html", null, true));
            echo ">
            ";
            // line 49
            if ($this->getAttribute(($context["tray"] ?? null), "label", array())) {
                // line 50
                echo "              <h3 class=\"toolbar-tray-name visually-hidden\">";
                echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, $this->getAttribute(($context["tray"] ?? null), "label", array()), "html", null, true));
                echo "</h3>
            ";
            }
            // line 52
            echo "            <nav class=\"toolbar-lining clearfix\" role=\"navigation\"";
            if ($this->getAttribute(($context["tray"] ?? null), "label", array())) {
                echo " aria-label=\"";
                echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, $this->getAttribute(($context["tray"] ?? null), "label", array()), "html", null, true));
            }
            echo "\">
              ";
            // line 53
            echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, $this->getAttribute(($context["tray"] ?? null), "links", array()), "html", null, true));
            echo "
            </nav>
          </div>
        ";
            echo trim(preg_replace('/>\s+</', '><', ob_get_clean()));
            // line 57
            echo "      </div>
    ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['key'], $context['tab'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 59
        echo "  </nav>
  ";
        // line 60
        echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, ($context["remainder"] ?? null), "html", null, true));
        echo "
</div>
";
    }

    public function getTemplateName()
    {
        return "modules/toolbar_themes/themes/base/templates/toolbar-themes--base-toolbar.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  128 => 60,  125 => 59,  118 => 57,  111 => 53,  103 => 52,  97 => 50,  95 => 49,  90 => 48,  88 => 47,  85 => 46,  79 => 43,  77 => 42,  75 => 41,  73 => 40,  68 => 38,  65 => 37,  61 => 36,  57 => 35,  52 => 34,  50 => 31,  49 => 30,  48 => 28,  43 => 26,);
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
 * Toolbar themes implementation for the administrative toolbar.
 *
 * Available variables:
 * - attributes: HTML attributes for the wrapper.
 * - toolbar_attributes: HTML attributes to apply to the toolbar.
 * - toolbar_heading: The heading or label for the toolbar.
 * - tabs: List of tabs for the toolbar.
 *   - attributes: HTML attributes for the tab container.
 *   - link: Link or button for the menu tab.
 *   - icon_attributes: tab icon classes and attributes to style SVG grunticons.
 * - trays: Toolbar tray list, each associated with a tab. Each tray in trays
 *   contains:
 *   - attributes: HTML attributes to apply to the tray.
 *   - label: The tray's label.
 *   - links: The tray menu links.
 * - remainder: Any non-tray, non-tab elements left to be rendered.
 * - show_icons: bool to show or hide icon markup.
 *
 * @see toobar_themes_preprocess_toolbar()
 *
 * @ingroup themeable
 */
#}
<div{{ attributes.addClass('toolbar') }}>
  {%
    set classes = [
      'toolbar-bar',
      show_icons ? 'has-icons' : 'no-icons',
      show_tabs ? 'has-tabs' : 'no-tabs',
    ]
  %}
  <nav{{ toolbar_attributes.addClass(classes).setAttribute('style', font_size) }}>
    <h2 class=\"visually-hidden\">{{ toolbar_heading }}</h2>
    {% for key, tab in tabs %}
      {% set tray = trays[key] %}
      <div{{ tab.attributes.addClass('toolbar-tab') }}>
        <span class=\"toolbar-tab__items-wrapper\">
          {{- tab.link -}}
          {%- if show_icons and show_tabs -%}
            {%- if tab.icon_attributes -%}
              <i{{ tab.icon_attributes.setAttribute('data-grunticon-embed', '') }}></i>
            {%- endif -%}
          {%- endif -%}
        </span>
        {% spaceless %}
          <div{{ tray.attributes }}>
            {% if tray.label %}
              <h3 class=\"toolbar-tray-name visually-hidden\">{{ tray.label }}</h3>
            {% endif %}
            <nav class=\"toolbar-lining clearfix\" role=\"navigation\"{% if tray.label %} aria-label=\"{{ tray.label }}{% endif %}\">
              {{ tray.links }}
            </nav>
          </div>
        {% endspaceless %}
      </div>
    {% endfor %}
  </nav>
  {{ remainder }}
</div>
", "modules/toolbar_themes/themes/base/templates/toolbar-themes--base-toolbar.html.twig", "/github/drupal8.dev/modules/toolbar_themes/themes/base/templates/toolbar-themes--base-toolbar.html.twig");
    }
}
