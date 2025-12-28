import { ImageResponse } from 'next/og';

export const runtime = 'edge';
export const alt = 'Puppy Pro - Dog Trainer - Pay Once, Train Forever - $39';
export const size = {
  width: 1200,
  height: 630,
};
export const contentType = 'image/png';

export default async function Image() {
  return new ImageResponse(
    (
      <div
        style={{
          height: '100%',
          width: '100%',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          background: 'linear-gradient(135deg, #0D9488 0%, #14B8A6 100%)',
          fontFamily: 'system-ui, -apple-system, sans-serif',
        }}
      >
        {/* Decorative paw prints */}
        <div
          style={{
            position: 'absolute',
            top: 50,
            left: 50,
            opacity: 0.1,
            display: 'flex',
            fontSize: 80,
            color: '#FFFFFF',
          }}
        >
          🐾
        </div>
        <div
          style={{
            position: 'absolute',
            bottom: 50,
            right: 50,
            opacity: 0.1,
            display: 'flex',
            fontSize: 80,
            color: '#FFFFFF',
          }}
        >
          🐾
        </div>

        {/* Main content */}
        <div
          style={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            textAlign: 'center',
            padding: '60px',
          }}
        >
          {/* Paw icon */}
          <div
            style={{
              fontSize: 100,
              marginBottom: 40,
              display: 'flex',
            }}
          >
            🐾
          </div>

          {/* Main title */}
          <h1
            style={{
              fontSize: 72,
              fontWeight: 800,
              color: '#FFFFFF',
              margin: 0,
              marginBottom: 20,
              lineHeight: 1.1,
            }}
          >
            Puppy Pro
          </h1>

          {/* Subtitle */}
          <p
            style={{
              fontSize: 48,
              fontWeight: 600,
              color: '#E0F2F1',
              margin: 0,
              marginBottom: 40,
            }}
          >
            Pay Once, Train Forever
          </p>

          {/* Price badge */}
          <div
            style={{
              background: 'linear-gradient(180deg, #F59E0B 0%, #D97706 100%)',
              borderRadius: 40,
              padding: '20px 60px',
              marginBottom: 40,
              display: 'flex',
            }}
          >
            <span
              style={{
                fontSize: 42,
                fontWeight: 800,
                color: '#FFFFFF',
              }}
            >
              $39 One-Time
            </span>
          </div>

          {/* Features */}
          <p
            style={{
              fontSize: 28,
              fontWeight: 500,
              color: '#E0F2F1',
              margin: 0,
              marginBottom: 20,
            }}
          >
            No Subscriptions • Unlimited Dogs • Works Offline
          </p>

          {/* Rating */}
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 10,
            }}
          >
            <span
              style={{
                fontSize: 32,
                color: '#FCD34D',
              }}
            >
              ★★★★★
            </span>
            <span
              style={{
                fontSize: 28,
                fontWeight: 600,
                color: '#FFFFFF',
              }}
            >
              4.9 (500+ reviews)
            </span>
          </div>
        </div>
      </div>
    ),
    {
      ...size,
    }
  );
}
