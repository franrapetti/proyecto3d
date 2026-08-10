import React from 'react';
import { Star, BadgeCheck } from 'lucide-react';
import './ReviewCarousel.css';

const REVIEWS = [
  {
    id: 1,
    name: 'Martín G.',
    location: 'Buenos Aires',
    comment: 'Llegó rapidísimo, excelente calidad del material y la presentación impecable. 10/10.',
    rating: 5,
  },
  {
    id: 2,
    name: 'Julieta S.',
    location: 'Córdoba',
    comment: 'Compré un mate imperial para regalo. La verdad superó mis expectativas. Volveré a comprar.',
    rating: 5,
  },
  {
    id: 3,
    name: 'Facundo L.',
    location: 'Mendoza',
    comment: 'El repuesto para la moto calzó perfecto. Muy buena atención y envío rápido.',
    rating: 5,
  },
  {
    id: 4,
    name: 'Camila P.',
    location: 'Santa Fe',
    comment: 'Hermosa la caja de municiones, se nota que es resistente. Todo llegó en orden.',
    rating: 4,
  },
  {
    id: 5,
    name: 'Diego M.',
    location: 'CABA',
    comment: 'El perfume riquísimo y dura un montón. El packaging es súper premium.',
    rating: 5,
  },
];

const ReviewCarousel = () => {
  return (
    <section className="review-carousel-section fade-in">
      <div className="review-carousel-container">
        <h2 className="review-carousel-title">Lo que dicen nuestros clientes</h2>
        <div className="review-carousel-wrapper">
          <div className="review-carousel-track">
            {REVIEWS.map((review) => (
              <div key={review.id} className="review-card-modern">
                <div className="review-card-header">
                  <div className="review-stars">
                    {Array.from({ length: 5 }).map((_, i) => (
                      <Star
                        key={i}
                        size={16}
                        fill={i < review.rating ? '#e5b62b' : 'none'}
                        color={i < review.rating ? '#e5b62b' : '#eaeaea'}
                      />
                    ))}
                  </div>
                  <span className="verified-buyer-badge">
                    <BadgeCheck size={14} /> Comprador Verificado
                  </span>
                </div>
                <p className="review-comment-text">"{review.comment}"</p>
                <div className="review-author">
                  <strong>{review.name}</strong>
                  <span className="review-location">{review.location}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};

export default ReviewCarousel;
