import { Metadata } from "next";
import Link from "next/link";
import { ArrowLeft, Dog } from "lucide-react";
import { Button } from "@/components/ui/button";

export const metadata: Metadata = {
  title: "Cookie Policy | Puppy Pro",
  description: "Cookie Policy for Puppy Pro. Our website uses minimal, essential cookies only - no tracking or advertising cookies.",
};

export default function CookiesPage() {
  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="sticky top-0 z-50 w-full border-b border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
        <div className="container mx-auto flex h-16 items-center justify-between px-4 md:px-6">
          <Link href="/" className="flex items-center gap-2">
            <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary">
              <Dog className="h-5 w-5 text-primary-foreground" />
            </div>
            <span className="text-lg font-semibold">Puppy Pro</span>
          </Link>
          <Button variant="ghost" size="sm" asChild>
            <Link href="/">
              <ArrowLeft className="mr-2 h-4 w-4" />
              Back to Home
            </Link>
          </Button>
        </div>
      </header>

      {/* Content */}
      <main className="container mx-auto px-4 py-12 md:px-6 md:py-16">
        <div className="mx-auto max-w-3xl">
          <h1 className="text-3xl font-bold tracking-tight md:text-4xl">Cookie Policy</h1>
          <p className="mt-4 text-muted-foreground">Last updated: January 2025</p>

          <div className="mt-8 space-y-8 text-foreground">
            <section>
              <h2 className="text-xl font-semibold">What Are Cookies?</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                Cookies are small text files that are placed on your device when you visit a website. They help
                the website remember information about your visit, which can make your next visit easier and
                the site more useful to you.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Our Cookie Philosophy</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                We believe in minimal data collection. Our website uses only essential cookies that are
                strictly necessary for the website to function. We do not use tracking cookies, advertising
                cookies, or third-party analytics cookies.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Cookies We Use</h2>
              <div className="mt-3 space-y-4">
                <div className="rounded-lg border border-border p-4">
                  <h3 className="font-medium">Essential Cookies</h3>
                  <p className="mt-1 text-sm text-muted-foreground">
                    These cookies are necessary for the website to work properly. They enable basic functions
                    like page navigation and access to secure areas.
                  </p>
                  <p className="mt-2 text-xs text-muted-foreground">
                    <strong>Duration:</strong> Session only (deleted when you close your browser)
                  </p>
                </div>
              </div>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Cookies We Don&apos;t Use</h2>
              <ul className="mt-3 list-disc pl-6 space-y-2 text-muted-foreground">
                <li><strong>Analytics cookies:</strong> We don&apos;t track how you use our website</li>
                <li><strong>Advertising cookies:</strong> We don&apos;t serve ads or track you for advertising</li>
                <li><strong>Social media cookies:</strong> We don&apos;t embed social media tracking</li>
                <li><strong>Third-party cookies:</strong> We don&apos;t allow third parties to place cookies</li>
              </ul>
            </section>

            <section>
              <h2 className="text-xl font-semibold">The iOS App</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                The Puppy Pro iOS app does not use cookies. All data is stored locally on your
                device using Apple&apos;s secure storage systems, not in cookies or browser storage.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Managing Cookies</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                Most web browsers allow you to control cookies through their settings. You can typically:
              </p>
              <ul className="mt-3 list-disc pl-6 space-y-2 text-muted-foreground">
                <li>See what cookies are stored and delete them individually</li>
                <li>Block third-party cookies</li>
                <li>Block cookies from specific websites</li>
                <li>Block all cookies</li>
                <li>Delete all cookies when you close your browser</li>
              </ul>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                Note that blocking all cookies may affect the functionality of some websites, though our
                website is designed to work with minimal cookie requirements.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Changes to This Policy</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                We may update this Cookie Policy from time to time. Any changes will be reflected on this
                page with an updated &quot;Last updated&quot; date.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Contact Us</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                If you have questions about our use of cookies, please contact us at{" "}
                <a href="mailto:support@puppypro.app" className="text-primary hover:underline">
                  support@puppypro.app
                </a>
              </p>
            </section>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-border py-8">
        <div className="container mx-auto px-4 text-center text-sm text-muted-foreground">
          <p>&copy; {new Date().getFullYear()} Puppy Pro. All rights reserved.</p>
          <div className="mt-2 flex justify-center gap-4">
            <Link href="/privacy" className="hover:text-foreground">Privacy</Link>
            <Link href="/terms" className="hover:text-foreground">Terms</Link>
            <Link href="/cookies" className="hover:text-foreground">Cookies</Link>
          </div>
        </div>
      </footer>
    </div>
  );
}
