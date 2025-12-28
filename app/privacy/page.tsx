import { Metadata } from "next";
import Link from "next/link";
import { ArrowLeft, Dog } from "lucide-react";
import { Button } from "@/components/ui/button";

export const metadata: Metadata = {
  title: "Privacy Policy | Puppy Pro",
  description: "Learn how Puppy Pro protects your privacy. We don't require accounts, don't sell your data, and store everything locally on your device.",
};

export default function PrivacyPage() {
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
          <h1 className="text-3xl font-bold tracking-tight md:text-4xl">Privacy Policy</h1>
          <p className="mt-4 text-muted-foreground">Last updated: January 2025</p>

          <div className="mt-8 space-y-8 text-foreground">
            <section>
              <h2 className="text-xl font-semibold">Our Privacy Philosophy</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                Puppy Pro is built with privacy at its core. We believe your training data belongs to you,
                not us. That&apos;s why we designed the app to work without requiring an account, without collecting
                personal information, and without selling your data.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Data We Don&apos;t Collect</h2>
              <ul className="mt-3 list-disc pl-6 space-y-2 text-muted-foreground">
                <li>No email addresses or personal accounts required</li>
                <li>No names, addresses, or phone numbers</li>
                <li>No location tracking or GPS data</li>
                <li>No photos unless you choose to add them locally</li>
                <li>No behavioral tracking or analytics about how you use the app</li>
              </ul>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Data Stored Locally on Your Device</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                All your training data, dog profiles, session logs, and progress tracking are stored locally on
                your device using Apple&apos;s secure storage systems. This data includes:
              </p>
              <ul className="mt-3 list-disc pl-6 space-y-2 text-muted-foreground">
                <li>Dog profiles (names, breeds, ages you enter)</li>
                <li>Training sessions and commands practiced</li>
                <li>Progress notes and session logs</li>
                <li>App preferences and settings</li>
              </ul>
            </section>

            <section>
              <h2 className="text-xl font-semibold">iCloud Sync (Optional)</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                If you enable iCloud sync on your device, your training data may be synced across your Apple
                devices using Apple&apos;s iCloud infrastructure. This sync is managed entirely by Apple and
                protected by your Apple ID security. We do not have access to your iCloud data.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Purchase Information</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                When you purchase Puppy Pro through the App Store, Apple handles all payment processing.
                We receive confirmation that a purchase was made but do not receive your payment details, credit
                card information, or Apple ID.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Support Communications</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                If you contact us for support at support@puppypro.app, we will receive and store your
                email address and any information you choose to share. We use this only to respond to your
                inquiry and do not add you to marketing lists or share your information.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Third-Party Services</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                Puppy Pro does not integrate with third-party analytics, advertising networks, or
                social media tracking. The app works fully offline and does not send data to external servers.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Children&apos;s Privacy</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                Our app does not collect personal information from anyone, including children. Families can
                safely use Puppy Pro with children to track their training progress.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Changes to This Policy</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                If we make changes to this privacy policy, we will update the &quot;Last updated&quot; date above.
                We encourage you to review this policy periodically.
              </p>
            </section>

            <section>
              <h2 className="text-xl font-semibold">Contact Us</h2>
              <p className="mt-3 text-muted-foreground leading-relaxed">
                If you have questions about this privacy policy or our practices, please contact us at{" "}
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
