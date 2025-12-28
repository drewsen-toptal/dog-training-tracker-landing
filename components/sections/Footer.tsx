import Link from "next/link";
import { Dog, Mail } from "lucide-react";

const footerLinks = {
  product: [
    { label: "Features", href: "#features" },
    { label: "Pricing", href: "#pricing" },
    { label: "Reviews", href: "#testimonials" },
    { label: "FAQ", href: "#faq" },
  ],
  support: [
    { label: "Contact", href: "mailto:support@puppypro.app" },
    { label: "Privacy", href: "/privacy" },
    { label: "Terms", href: "/terms" },
    { label: "Cookies", href: "/cookies" },
  ],
};

export function Footer() {
  return (
    <footer className="border-t border-border bg-muted/30">
      <div className="container mx-auto px-4 py-12 md:px-6 md:py-16">
        <div className="grid gap-8 md:grid-cols-2 lg:grid-cols-3">
          {/* Brand Column */}
          <div className="md:col-span-2 lg:col-span-1">
            <Link href="/" className="flex items-center gap-2">
              <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary">
                <Dog className="h-4 w-4 text-primary-foreground" />
              </div>
              <span className="text-lg font-semibold">Puppy Pro</span>
            </Link>
            <p className="mt-4 text-sm text-muted-foreground">
              The dog training app that respects your wallet and your time.
              Track progress, master commands, train any dog.
            </p>

            {/* Contact */}
            <a
              href="mailto:support@puppypro.app"
              className="mt-6 inline-flex items-center gap-2 text-sm text-muted-foreground transition-colors hover:text-foreground"
            >
              <Mail className="h-4 w-4" />
              support@puppypro.app
            </a>
          </div>

          {/* Product Links */}
          <div>
            <h4 className="mb-4 text-sm font-semibold">Product</h4>
            <ul className="space-y-3 text-sm">
              {footerLinks.product.map((link) => (
                <li key={link.label}>
                  <a href={link.href} className="text-muted-foreground transition-colors hover:text-foreground">
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Support & Legal Links */}
          <div>
            <h4 className="mb-4 text-sm font-semibold">Support & Legal</h4>
            <ul className="space-y-3 text-sm">
              {footerLinks.support.map((link) => (
                <li key={link.label}>
                  {link.href.startsWith("/") ? (
                    <Link href={link.href} className="text-muted-foreground transition-colors hover:text-foreground">
                      {link.label}
                    </Link>
                  ) : (
                    <a href={link.href} className="text-muted-foreground transition-colors hover:text-foreground">
                      {link.label}
                    </a>
                  )}
                </li>
              ))}
            </ul>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="mt-12 flex flex-col items-center justify-between gap-4 border-t border-border pt-8 md:flex-row">
          <p className="text-sm text-muted-foreground">
            &copy; {new Date().getFullYear()} Puppy Pro. All rights reserved.
          </p>
          <div className="flex gap-4">
            <Link href="/privacy" className="text-sm text-muted-foreground transition-colors hover:text-foreground">
              Privacy
            </Link>
            <Link href="/terms" className="text-sm text-muted-foreground transition-colors hover:text-foreground">
              Terms
            </Link>
            <Link href="/cookies" className="text-sm text-muted-foreground transition-colors hover:text-foreground">
              Cookies
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}
