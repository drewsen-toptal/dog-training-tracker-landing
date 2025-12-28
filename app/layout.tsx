import type { Metadata, Viewport } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
  display: "swap",
});

export const viewport: Viewport = {
  themeColor: "#0D9488",
  width: "device-width",
  initialScale: 1,
};

export const metadata: Metadata = {
  title: "Dog Training Tracker | Pay Once, Train Forever",
  description: "The dog training app that respects your wallet and your time. No subscriptions. No account required. No limits on how many dogs you can train.",
  keywords: ["dog training", "puppy training", "dog training app", "dog tracker", "pet training"],
  authors: [{ name: "Dog Training Tracker" }],
  metadataBase: new URL("https://dogtrainingtracker.app"),
  alternates: {
    canonical: "/",
  },
  robots: {
    index: true,
    follow: true,
  },
  openGraph: {
    title: "Dog Training Tracker | Pay Once, Train Forever",
    description: "The dog training app that respects your wallet and your time. No subscriptions. No account required.",
    type: "website",
    locale: "en_US",
    siteName: "Dog Training Tracker",
  },
  twitter: {
    card: "summary_large_image",
    title: "Dog Training Tracker | Pay Once, Train Forever",
    description: "The dog training app that respects your wallet and your time.",
  },
};

// JSON-LD Structured Data
const jsonLd = {
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  name: "Dog Training Tracker",
  applicationCategory: "LifestyleApplication",
  operatingSystem: "iOS",
  offers: {
    "@type": "Offer",
    price: "39",
    priceCurrency: "USD",
  },
  aggregateRating: {
    "@type": "AggregateRating",
    ratingValue: "4.9",
    ratingCount: "500",
  },
  description: "The dog training app that respects your wallet and your time. No subscriptions. No account required.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="scroll-smooth">
      <head>
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
        />
      </head>
      <body className={`${inter.variable} font-sans antialiased`}>
        {/* Skip to main content link for accessibility */}
        <a
          href="#main-content"
          className="sr-only focus:not-sr-only focus:fixed focus:left-4 focus:top-4 focus:z-50 focus:rounded-md focus:bg-primary focus:px-4 focus:py-2 focus:text-primary-foreground"
        >
          Skip to main content
        </a>
        {children}
      </body>
    </html>
  );
}
